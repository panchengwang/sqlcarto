#include <iostream>
#include <string>
#include <stdlib.h>
#include <math.h>
#include <sstream>
#include <iomanip> 

void usage(char** argv);
std::string make_command_sql(const std::string &executor, const std::string &sql);
int main(int argc, char** argv) {
  if (argc != 16){
    usage(argv);
    return EXIT_FAILURE;
  }

  int i = 1;
  std::string host = argv[i++];
  std::string port = argv[i++];
  std::string dbname = argv[i++];
  std::string user = argv[i++];
  std::string schemaname = argv[i++];
  std::string gridname = argv[i++];
  int srid = atoi(argv[i++]);
  double minx = atof(argv[i++]);
  double miny = atof(argv[i++]);
  int nrows = atoi(argv[i++]);
  int ncols = atoi(argv[i++]);
  double xstep = atof(argv[i++]);
  double ystep = atof(argv[i++]);
  int num_per_table = atoi(argv[i++]);
  int concurrent = atoi(argv[i++]);

  int num_tables = ceil((nrows*ncols)/(double)num_per_table);

  std::string sqlexecutor = "psql -h " + host + " -p " + port + " -U " + user + " -d " + dbname ;
  std::stringstream sql;
  sql << "create table \"" << schemaname << "\".\"" << gridname << "\"(" 
    << "   _id bigint, " 
    << "   _center geometry(POINT," << srid << ")," 
    << "   _geo geometry(POLYGON," << srid << ")" 
    << ") partition by range(_id)";

  std::cout << make_command_sql(sqlexecutor, sql.str()) << std::endl;

  long firstid,lastid;

  int count = 0;
  for(i=0; i<num_tables; i++){
    std::stringstream sql;
    firstid = i * num_per_table;
    lastid = firstid + num_per_table -1;
    lastid = (lastid > ncols*nrows-1) ? ncols*nrows-1 : lastid;
    sql << "select sc_create_grid("
        << "'" << schemaname << "','" << gridname << "_" << i << "'," << srid << ","
        << std::setprecision(25) << minx << "," << miny << "," 
        << nrows << "," << ncols << ","
        << xstep << "," << ystep << ","
        << firstid << "," << lastid 
        <<")";
    std::cout << make_command_sql(sqlexecutor, sql.str()) << " & " << std::endl;
    count ++; 
    if(count >= concurrent){
      std::cout << "wait" << std::endl;
      count = 0;
    }
  }

  if(count > 0){
    std::cout << "wait" << std::endl;
  }

  for(i=0; i<num_tables; i++){
    std::stringstream sql;
    firstid = i * num_per_table;
    lastid = firstid + num_per_table -1;
    lastid = (lastid > ncols*nrows-1) ? ncols*nrows-1 : lastid;
    sql << "alter table \"" << schemaname << "\".\"" << gridname << "\" "
        << " attach partition \"" << schemaname << "\".\"" << gridname << "_" << i << "\"" 
        << " for values from ("  << std::setprecision(25) << firstid << ") to (" << lastid+1 << ")";
    std::cout << make_command_sql(sqlexecutor, sql.str()) << std::endl;
  }

  return EXIT_SUCCESS;
}

void usage(char** argv){
  std::cerr << "command: " << argv[0] << std::endl;
  std::cerr << "This command can generate a grid table include many partition tables in parallel." << std::endl;
  std::cerr << argv[0] << " <host> <port> <dbname> <user> <schemaname> <gridname> <srid> <minx> <miny> <nrows> <ncols> <xstep> <ystep> <num of records per sub table> <Number of concurrent>" << std::endl;
}

std::string make_command_sql(const std::string &executor, const std::string& sql){
  return executor + " -c \"" + sql + "\"";
}