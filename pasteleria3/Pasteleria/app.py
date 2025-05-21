from flask import Flask, request, render_template, redirect, url_for, session, flash
from conectar import conectar
import bcrypt

app = Flask(__name__)
app.secret_key = 'clave_secreta_segura'

@app.route('/', methods=['GET', 'POST'])
def inicio():
    # Verificar si viene de creación exitosa de cuenta
    cuenta_creada = session.pop('cuenta_creada_exito', False)
    
    error = None
    mostrar_modal = False
    conexion = None

    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '').strip()

        if not username or not password:
            error = "Por favor, ingresa correo y contraseña."
            mostrar_modal = True
        else:
            try:
                conexion = conectar()
                with conexion.cursor() as cursor:
                    cursor.execute("SELECT nombre, contraseña FROM Usuarios WHERE correo = %s", (username,))
                    resultado = cursor.fetchone()

                    if resultado:
                        nombre = resultado['nombre']
                        password_hash = resultado['contraseña']
                        if bcrypt.checkpw(password.encode('utf-8'), password_hash.encode('utf-8')):
                            session['usuario'] = nombre
                            # Redirigir a la página de inicio tras login exitoso
                            return redirect(url_for('inicio'))
                        else:
                            error = "Usuario o contraseña incorrectos"
                            mostrar_modal = True
                    else:
                        error = "Usuario o contraseña incorrectos"
                        mostrar_modal = True
            except Exception as err:
                error = f"Error en la base de datos: {err}"
            finally:
                if conexion:
                    conexion.close()

    return render_template(
        'index.html',
        error=error,
        mostrar_modal=mostrar_modal,
        cuenta_creada=cuenta_creada
    )

@app.route('/perfil')
def perfil():
    if 'usuario' in session:
        return render_template('perfil.html', nombre=session['usuario'])
    return redirect(url_for('inicio'))

@app.route('/menu')
def menu():
    if 'usuario' not in session:
        return redirect(url_for('inicio'))
    return render_template('menu.html')

@app.route('/contacto')
def contacto():
    if 'usuario' not in session:
        return redirect(url_for('inicio'))
    return render_template('contacto.html')

@app.route('/carrito')
def carrito():
    if 'usuario' not in session:
        return redirect(url_for('inicio'))
    return render_template('carrito.html')

@app.route('/buscar')
def buscar():
    if 'usuario' not in session:
        return redirect(url_for('inicio'))
    return "Página de búsqueda (aún en construcción)"

@app.route('/logout')
def logout():
    session.pop('usuario', None)
    flash("Sesión cerrada correctamente", "success")
    return redirect(url_for('inicio'))

@app.route('/crear_cuenta', methods=['GET', 'POST'])
def crear_cuenta():
    conexion = None
    if request.method == 'POST':
        nombre = request.form.get('nombre', '').strip()
        correo = request.form.get('correo', '').strip()
        contraseña = request.form.get('contraseña', '').strip()
        confirmar_contraseña = request.form.get('confirmar_contraseña', '').strip()

        if not nombre or not correo or not contraseña or not confirmar_contraseña:
            flash("Todos los campos son obligatorios.", "error")
            return redirect(url_for('crear_cuenta'))
        
        if contraseña != confirmar_contraseña:
            flash("Las contraseñas no coinciden.", "error")
            return redirect(url_for('crear_cuenta'))
        
        if len(contraseña) < 4:
            flash("La contraseña debe tener al menos 4 caracteres.", "error")
            return redirect(url_for('crear_cuenta'))

        try:
            hashed_password = bcrypt.hashpw(contraseña.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
            conexion = conectar()
            with conexion.cursor() as cursor:
                cursor.execute("SELECT Correo FROM Usuarios WHERE Correo = %s", (correo,))
                if cursor.fetchone():
                    flash("El correo ya está registrado.", "error")
                    return redirect(url_for('crear_cuenta'))
                
                cursor.execute(
                    "INSERT INTO Usuarios (Correo, Contraseña, Nombre, Rol, FechaRegistro) "
                    "VALUES (%s, %s, %s, 'cliente', CURDATE())",
                    (correo, hashed_password, nombre)
                )
                conexion.commit()
                session['cuenta_creada_exito'] = True
                return redirect(url_for('inicio'))
        except Exception as err:
            flash(f"Error al crear la cuenta: {err}", "error")
        finally:
            if conexion:
                conexion.close()

    return render_template('crear_cuenta.html')

@app.route('/recuperar_contrasena', methods=['GET', 'POST'])
def recuperar_contrasena():
    conexion = None
    if request.method == 'POST':
        correo = request.form.get('correo', '').strip()
        if not correo:
            flash("Ingresa tu correo electrónico.", "error")
            return redirect(url_for('recuperar_contrasena'))
        
        try:
            conexion = conectar()
            with conexion.cursor() as cursor:
                cursor.execute("SELECT Correo FROM Usuarios WHERE Correo = %s", (correo,))
                if not cursor.fetchone():
                    flash("Este correo no está registrado.", "error")
                    return redirect(url_for('recuperar_contrasena'))
                
                # Aquí enviarías un correo real en producción
                flash("Se ha enviado un enlace de recuperación a tu correo electrónico.", "success")
                return redirect(url_for('inicio'))
        except Exception as err:
            flash(f"Error: {err}", "error")
        finally:
            if conexion:
                conexion.close()

    return render_template('recuperar_contrasena.html')

if __name__ == '__main__':
    app.run(debug=True)
