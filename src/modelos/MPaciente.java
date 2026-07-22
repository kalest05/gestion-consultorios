package modelos;
import java.util.Date;

/**
 * Clase MPaciente representa un paciente que es registrado en el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion registrada.
 * Este encapsula toda la información relacionada con los pacientes del hospital, utilizarse
 * en el controlador {@link controladores.Cpacientes} y llevar a cabo acciones mediante
 * la interfaz en {@link vistas.Pacientes}
 * </p>
* @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class MPaciente {
	String nombre;
	String apellidoP;
	String apellidoM;
	Date fechaNac;
	int edad;
	String Alergia;
	/**
	 * @return the alergia
	 */
	public String getAlergia() {
		return Alergia;
	}
	/**
	 * @param alergia the alergia to set
	 */
	public void setAlergia(String alergia) {
		Alergia = alergia;
	}
	String genero;
	String religion;
	String telefono;
	String curp;
	String localidad;
	String municipio;
	String numCalle;
	String Sangre;
	String Municipio;
	String Localidad;
	String Next;
	int id;
	
	
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	/**
	 * @return the next
	 */
	public String getNext() {
		return Next;
	}
	/**
	 * @param next the next to set
	 */
	public void setNext(String next) {
		Next = next;
	}
	/**
	 * @return the sangre
	 */
	public String getSangre() {
		return Sangre;
	}
	/**
	 * @param sangre the sangre to set
	 */
	public void setSangre(String sangre) {
		Sangre = sangre;
	}
	/**
	 * @return el nombre
	 */
	public String getNombre() {
		return nombre;
	}
	/**
	 * @param nombre el nombre a configurar
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	/**
	 * @return el apellidoP
	 */
	public String getApellidoP() {
		return apellidoP;
	}
	/**
	 * @param apellidoP el apellidoP a configurar
	 */
	public void setApellidoP(String apellidoP) {
		this.apellidoP = apellidoP;
	}
	/**
	 * @return el apellidoM
	 */
	public String getApellidoM() {
		return apellidoM;
	}
	/**
	 * @param apellidoM el apellidoM a configurar
	 */
	public void setApellidoM(String apellidoM) {
		this.apellidoM = apellidoM;
	}
	/**
	 * @return la fechaNac
	 */
	public Date getFechaNac() {
		return fechaNac;
	}
	/**
	 * @param fechaNac la fechaNac a configuar
	 */
	public void setFechaNac(Date fechaNac) {
		this.fechaNac = fechaNac;
	}
	/**
	 * @return la edad
	 */
	public int getEdad() {
		return edad;
	}
	/**
	 * @param edad la edad a establecer
	 */
	public void setEdad(int edad) {
		this.edad = edad;
	}
	/**
	 * @return el genero
	 */
	public String getGenero() {
		return genero;
	}
	/**
	 * @param genero el genero a establecer
	 */
	public void setGenero(String genero) {
		this.genero = genero;
	}
	/**
	 * @return la religion
	 */
	public String getReligion() {
		return religion;
	}
	/**
	 * @param religion la religion a establecer
	 */
	public void setReligion(String religion) {
		this.religion = religion;
	}
	/**
	 * @return el telefono
	 */
	public String getTelefono() {
		return telefono;
	}
	/**
	 * @param telefono el telefono para configurar
	 */
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	/**
	 * @return la curp
	 */
	public String getCurp() {
		return curp;
	}
	/**
	 * @param curp la curp para configurar
	 */
	public void setCurp(String curp) {
		this.curp = curp;
	}
	/**
	 * @return la localidad
	 */
	public String getLocalidad() {
		return localidad;
	}
	/**
	 * @param localidad la localidad a establecer
	 */
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}
	/**
	 * @return el municipio
	 */
	public String getMunicipio() {
		return municipio;
	}
	/**
	 * @param municipio el municipio a establecer
	 */
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	/**
	 * @return el numCalle
	 */
	public String getNumCalle() {
		return numCalle;
	}
	/**
	 * @param numCalle the numCalle para establecer
	 */
	public void setNumCalle(String numCalle) {
		this.numCalle = numCalle;

	}

}