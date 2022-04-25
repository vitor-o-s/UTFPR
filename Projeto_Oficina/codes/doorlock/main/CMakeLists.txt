idf_component_register(SRCS "doorlock.c"
                    INCLUDE_DIRS "."
                    EMBED_TXTFILES howsmyssl_com_root_cert.pem
                    postman_root_cert.pem
                    telegram_certificate.pem
                    ca.pem)
