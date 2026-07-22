package modelos;

/**
 * Clase <b>{@code MSubespecialides}</b> representa una subespecialidad
 * registrada en el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion
 * registrada. Este encapsula toda la información relacionada con una
 * subespecialidad para utilizarse en el controlador
 * {@link controladores.Cmedicos} y llevar a cabo acciones mediante la interfaz
 * en {@link vistas.Medicos}
 * </p>
 * 
 * @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class MSubespecialides {

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
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return Descripcion;
	}
	/**
	 * @param descripcion the descripcion to set
	 */
	public void setDescripcion(String descripcion) {
		Descripcion = descripcion;
	}
	/**
	 * @return the idEspecialidad
	 */
	public String getIdEspecialidad() {
		return idEspecialidad;
	}
	/**
	 * @param idEspecialidad the idEspecialidad to set
	 */
	public void setIdEspecialidad(String idEspecialidad) {
		this.idEspecialidad = idEspecialidad;
	}
	String Nombre;
	
	String Descripcion;
	String idEspecialidad;

	

}