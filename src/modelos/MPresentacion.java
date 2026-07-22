package modelos;

/**
 * Clase <b>{@code MPresentacion}</b> representa una presentacion registrada en
 * el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion
 * registrada. Este encapsula toda la información relacionada con una
 * presentación para utilizarse en el controlador
 * {@link controladores.Cmedicamento} y llevar a cabo acciones mediante la
 * interfaz en {@link vistas.Presentacion}
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class MPresentacion {
	String Nombre;
	String Descripcion;

	public String getNombre() {
		return Nombre;
	}

	public void setNombre(String nombre) {
		Nombre = nombre;
	}

	public String getDescripcion() {
		return Descripcion;
	}

	public void setDescripcion(String descripcion) {
		Descripcion = descripcion;
	}

}