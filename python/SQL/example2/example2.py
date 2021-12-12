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

try:
    connection.execute(struct_db)
except:
    print("Struct_db já criado.")

connection.commit()

# Adicionar dados com apenas alguns campos
insert = """
INSERT INTO CLIENTES(NOME, ESTADO)
VALUES(?, ?);
"""
data = [('Vinicius', 'ES')]

connection.executemany(insert, data)
connection.commit()

# Cursor create
## Esta função SQL recebe todo o conteudo da tabela passada (Clientes)

cursor = connection.execute('SELECT * FROM CLIENTES;')
cursor.fetchall()

# Adicionar todos os campos - chave primária
insert2 = """
INSERT INTO CLIENTES(NOME, ENDEREÇO, CIDADE, ESTADO)
VALUES(?, ?, ?, ?);
"""
data2 = ('Bruce', 'Reservado', 'Gotham', 'DC')
connection.execute(insert2, data2)
connection.commit()

cursor = connection.execute('SELECT * FROM CLIENTES;')
cursor.fetchall()

# Insersão de múltiplos registros
data3 = [('Ana', 'Carvalho Hotel', 'Rio de Janeiro', 'RJ'),
         ('Breno', 'Limoeiro Club', 'São Paulo', 'SP'),
         ('Carla', 'Rua das Goiabeiras', 'Belo Horizonte', 'MG'),
         ('Daniel', 'Bairro do Jacarandá', 'Vitória', 'ES')
]

connection.executemany(insert2, data3)
connection.commit()

cursor = connection.execute('SELECT * FROM CLIENTES;')
rows = cursor.fetchall()

# Criação da tabela usando pandas

import pandas as pd 
sql_data = pd.DataFrame(rows, columns=[x[0] for x in cursor.description])

print('Data base:\n')
print(sql_data)

connection.close()
