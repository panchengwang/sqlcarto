#include "sqlcarto.h"
#include "bytea2cstring.h"
#include <curl/curl.h>



//
struct upload_context
{
    const char *data; // 需要发送的信息，应该符合email邮件格式
    size_t bytes_read;
};

static size_t read_data(char *ptr, size_t size, size_t nmemb, void *userp)
{
    struct upload_context *upload_ctx = (struct upload_context *)userp;
    const char *data;
    size_t room = size * nmemb;

    if ((size == 0) || (nmemb == 0) || ((size * nmemb) < 1))
    {
        return 0;
    }

    data = &upload_ctx->data[upload_ctx->bytes_read];

    if (data)
    {
        size_t len = strlen(data);
        if (room < len)
            len = room;
        memcpy(ptr, data, len);
        upload_ctx->bytes_read += len;

        return len;
    }

    return 0;
}

PG_FUNCTION_INFO_V1(sc_send_mail); // 发送邮件

Datum sc_send_mail(PG_FUNCTION_ARGS)
{
    char *errormessage = NULL;
    bool sendok = false;

    // 获取参数
    char *sender = bytea_to_cstring(PG_GETARG_BYTEA_P(0));
    char *reciever = bytea_to_cstring(PG_GETARG_BYTEA_P(1));
    char *subject = bytea_to_cstring(PG_GETARG_BYTEA_P(2));
    char *content = bytea_to_cstring(PG_GETARG_BYTEA_P(3));
    char *smtp = bytea_to_cstring(PG_GETARG_BYTEA_P(4));
    char *password = bytea_to_cstring(PG_GETARG_BYTEA_P(5));
    CURL *curl;
    CURLcode res = CURLE_OK;
    struct curl_slist *recipients = NULL;
    struct upload_context upload_ctx;
    upload_ctx.bytes_read = 0;

    // 将发送内容组合成符合邮件的格式
    int32 datalen = strlen("To: ") + strlen(reciever) + 2       // 接收者邮箱地址
                    + strlen("Subject: ") + strlen(subject) + 2 // 邮件标题
                    + 2                                         // 标题和邮件内容间的换行
                    + strlen(content) + 2                       // 邮件内容
                    + 2;                                        // 邮件结束处的换行
    char *send_data = (char *)malloc(datalen + 1);
    memset(send_data, 0, datalen + 1);
    sprintf(send_data, "To: %s\r\n"
                       "Subject: %s\r\n"
                       "\r\n"
                       "%s\r\n"
                       "\r\n",
            reciever,
            subject,
            content);
    upload_ctx.data = send_data;

    curl = curl_easy_init();
    if (curl)
    {
        curl_easy_setopt(curl, CURLOPT_USERNAME, sender);
        curl_easy_setopt(curl, CURLOPT_PASSWORD, password);
        curl_easy_setopt(curl, CURLOPT_URL, smtp);
        curl_easy_setopt(curl, CURLOPT_MAIL_FROM, sender);
        recipients = curl_slist_append(recipients, reciever);
        curl_easy_setopt(curl, CURLOPT_MAIL_RCPT, recipients);
        curl_easy_setopt(curl, CURLOPT_READFUNCTION, read_data);
        curl_easy_setopt(curl, CURLOPT_READDATA, &upload_ctx);
        curl_easy_setopt(curl, CURLOPT_UPLOAD, 1L);
        curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);
        res = curl_easy_perform(curl);
        if (res != CURLE_OK)
        {
            errormessage = strdup(curl_easy_strerror(res));
            sendok = false;
        }
        else
        {
            errormessage = strdup("OK");
            sendok = true;
        }
        curl_slist_free_all(recipients);
        curl_easy_cleanup(curl);
    }
    else
    {
        errormessage = strdup("can not init curl");
        sendok = false;
    }

    free(sender);
    free(reciever);
    free(subject);
    free(content);
    free(smtp);
    free(password);
    free(send_data);
    if (!sendok)
    {
        free(errormessage);
        PG_RETURN_BOOL(FALSE);
    }
    free(errormessage);
    PG_RETURN_BOOL(TRUE);
}
