package modelos;

/**
 * Clase <b>{@code MDepartamentos}</b> representa una consulta registrada en el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion
 * registrada. Este encapsula toda la información relacionada con una 
 * consulta para utilizarse en el controlador {@link controladores.Cmedicos} y
 * llevar a cabo acciones mediante la interfaz en {@link vistas.Medicos}
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class MDepartamentos {
String Nombre;
String TelExt;
int Empleados;
/**
 * @return the nombre
 */
public String getNombre() {
	return Nombre;
}
/**
 * @param nombre the nombre to set
 */
public void setNombre(String nombre) {
	Nombre = nombre;
}
/**
 * @return the telExt
 */
public String getTelExt() {
	return TelExt;
}
/**
 * @param telExt the telExt to set
 */
public void setTelExt(String telExt) {
	TelExt = telExt;
}
/**
 * @return the empleados
 */
public int getEmpleados() {
	return Empleados;
}
/**
 * @param empleados the empleados to set
 */
public void setEmpleados(int empleados) {
	Empleados = empleados;
}


}