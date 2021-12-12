import sqlite3

struct_db = """
CREATE TABLE CLIENTES (
    ID_CLIENTE      INTEGER     PRIMARY KEY     AUTOINCREMENT       NOT NULL,
    NOME            TEXT        NOT NULL,
    ENDEREÇO        TEXT,
    CIDADE          TEXT,
    ESTADO          TEXT
);
"""

# Se o arquivo não existir, ele é criado.
connection = sqlite3.connect('data_base.db')


connection.execute(struct_db)
connection.commit()

connection.close()