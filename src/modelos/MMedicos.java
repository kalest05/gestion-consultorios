package modelos;

import java.util.Date;

/**
 * Clase MMedicos representa un medico que es registrado en el sistema.
 * <p>
 * Esta clase contiene los getters y setters donde se almacena la informacion registrada.
 * Este encapsula toda la información relacionada con los medicos del hospital, utilizarse
 * en el controlador {@link controladores.Cmedicos} y llevar a cabo acciones mediante
 * la interfaz en {@link vistas.Medicos}
 * </p>
* @author Milagros Guadalupe Camacho Camacho
 * @author Kalecxa Guadalupe Sandoval Encines
 * @author Lilian Sarahi Tapia Garcia
 * @version 2.0
 * @since 01-07-2025
 */
public class MMedicos {
	
	String ApellidoP;
	String ApellidoM;
	String Esp;
	String Dep;
	String Sub;
	String Correo;
	Date FechaNac;
	String Telefono;
	String Cedula;
	String CURP;
	String RFC;
	int NumCasa;
	String NomCalle;
	String Mun;
	String Loc;
	
String Nombre;
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
 * @return the apellidoP
 */
public String getApellidoP() {
	return ApellidoP;
}
/**
 * @param apellidoP the apellidoP to set
 */
public void setApellidoP(String apellidoP) {
	ApellidoP = apellidoP;
}
/**
 * @return the apellidoM
 */
public String getApellidoM() {
	return ApellidoM;
}
/**
 * @param apellidoM the apellidoM to set
 */
public void setApellidoM(String apellidoM) {
	ApellidoM = apellidoM;
}
/**
 * @return the esp
 */
public String getEsp() {
	return Esp;
}
/**
 * @param esp the esp to set
 */
public void setEsp(String esp) {
	Esp = esp;
}
/**
 * @return the dep
 */
public String getDep() {
	return Dep;
}
/**
 * @param dep the dep to set
 */
public void setDep(String dep) {
	Dep = dep;
}
/**
 * @return the sub
 */
public String getSub() {
	return Sub;
}
/**
 * @param sub the sub to set
 */
public void setSub(String sub) {
	Sub = sub;
}
/**
 * @return the correo
 */
public String getCorreo() {
	return Correo;
}
/**
 * @param correo the correo to set
 */
public void setCorreo(String correo) {
	Correo = correo;
}
/**
 * @return the fechaNac
 */
public Date getFechaNac() {
	return FechaNac;
}
/**
 * @param fechaNac the fechaNac to set
 */
public void setFechaNac(Date fechaNac) {
	FechaNac = fechaNac;
}
/**
 * @return the telefono
 */
public String getTelefono() {
	return Telefono;
}
/**
 * @param telefono the telefono to set
 */
public void setTelefono(String telefono) {
	Telefono = telefono;
}
/**
 * @return the cedula
 */
public String getCedula() {
	return Cedula;
}
/**
 * @param cedula the cedula to set
 */
public void setCedula(String cedula) {
	Cedula = cedula;
}
/**
 * @return the cURP
 */
public String getCURP() {
	return CURP;
}
/**
 * @param cURP the cURP to set
 */
public void setCURP(String cURP) {
	CURP = cURP;
}
/**
 * @return the rFC
 */
public String getRFC() {
	return RFC;
}
/**
 * @param rFC the rFC to set
 */
public void setRFC(String rFC) {
	RFC = rFC;
}
/**
 * @return the numCasa
 */
public int getNumCasa() {
	return NumCasa;
}
/**
 * @param numCasa the numCasa to set
 */
public void setNumCasa(int numCasa) {
	NumCasa = numCasa;
}
/**
 * @return the nomCalle
 */
public String getNomCalle() {
	return NomCalle;
}
/**
 * @param nomCalle the nomCalle to set
 */
public void setNomCalle(String nomCalle) {
	NomCalle = nomCalle;
}
/**
 * @return the mun
 */
public String getMun() {
	return Mun;
}
/**
 * @param mun the mun to set
 */
public void setMun(String mun) {
	Mun = mun;
}
/**
 * @return the loc
 */
public String getLoc() {
	return Loc;
}
/**
 * @param loc the loc to set
 */
public void setLoc(String loc) {
	Loc = loc;
}


}