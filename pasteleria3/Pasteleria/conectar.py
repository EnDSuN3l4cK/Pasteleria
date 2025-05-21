import pymysql

def conectar():
    return pymysql.connect(
        host='localhost',
        user='root',
        passwd='Memc.130201',
        db='pasteleria',
        cursorclass=pymysql.cursors.DictCursor  # Para obtener diccionarios en lugar de tuplas
    )
