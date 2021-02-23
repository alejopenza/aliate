/** Representa el parametro URL que se va a utilizar en el endpoint cuando se utiliza el WSService. */
public class WSParameter {

	public String name { get; set; }
	public Boolean isRequired { get; set; }
	public Boolean urlEncoding { get; set; }
	public String value { get; set; }

    /**
     * Constructor que recibe nombre, valor y si es requerido del paramero url del WS. Este presetea el campo urlEncoding en true
     */
	public WSParameter(String name, String value, Boolean isRequired) {
		this(name, value, IsRequired, true);
	}

	public WSParameter(String name, String value, Boolean isRequired, Boolean urlEncoding) {
		this.name = name;
		this.isRequired = IsRequired;
		this.value = value;
		this.urlEncoding = urlEncoding;
	}

    /** Devuelve calor del parametro como string. Codifica el cvalor bajo UTF-8 dependiendo si el campo 'urlEncoding' esta prendido.*/
	public override String toString() {
		if (urlEncoding) {
			return (!String.isBlank(value)) ? EncodingUtil.urlEncode(value, 'UTF-8') : '';
		} else {
			return value;
		}
	}
}