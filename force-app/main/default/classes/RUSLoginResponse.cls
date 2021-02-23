public class RUSLoginResponse {

	public Integer httpStatus;
	public String message;
	public Object body;

	public static RUSloginResponse parse(String json) {
		return (RUSloginResponse) System.JSON.deserialize(json, RUSloginResponse.class);
	}

	public void setBody (String value){
		this.body =  value != null ? value : '';
	}

	public void setMessage (String value){
		this.message =  value != null ? value : '';
	}

	public void setHttpStatus (Integer value){
		this.httpStatus =  value != null ? value : null;
	}
}