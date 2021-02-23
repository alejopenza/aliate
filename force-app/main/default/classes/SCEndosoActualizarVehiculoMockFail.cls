@isTest
global with sharing class SCEndosoActualizarVehiculoMockFail implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        //TODO el body siguiente habría que reemplazarlo por una response 200 real
        res.setBody('{"Endorsement":null,"HasError":true,"HasWarning":false,"HasInformation":false,"Messages":[{"NombreServicio":"","VersionServicio":"","Description":"Error al actualizar el vehículo.","MessageBeautiful":"Model no fue encontrado","StackTrace":"\r\nServer stack trace: \r\n   at System.ServiceModel.Channels.ServiceChannel.HandleReply(ProxyOperationRuntime operation, ProxyRpc& rpc)\r\n   at System.ServiceModel.Channels.ServiceChannel.Call(String action, Boolean oneway, ProxyOperationRuntime operation, Object[] ins, Object[] outs, TimeSpan timeout)\r\n   at System.ServiceModel.Channels.ServiceChannel.Call(String action, Boolean oneway, ProxyOperationRuntime operation, Object[] ins, Object[] outs)\r\n   at System.ServiceModel.Channels.ServiceChannelProxy.InvokeService(IMethodCallMessage methodCall, ProxyOperationRuntime operation)\r\n   at System.ServiceModel.Channels.ServiceChannelProxy.Invoke(IMessage message)\r\n\r\nException rethrown at [0]: \r\n   at System.Runtime.Remoting.Proxies.RealProxy.HandleReturnMessage(IMessage reqMsg, IMessage retMsg)\r\n   at System.Runtime.Remoting.Proxies.RealProxy.PrivateInvoke(MessageData& msgData, Int32 type)\r\n   at VehicleAPI.VehicleGW.VehicleAPIPortType.updateVehicle(updateVehicle request)\r\n   at VehicleAPI.VehicleGW.VehicleAPIPortTypeClient.VehicleAPI.VehicleGW.VehicleAPIPortType.updateVehicle(updateVehicle request) in C:\\agent-win10\\_work\\73\\s\\PC\\VehicleAPI\\Service References\\VehicleGW\\Reference.cs:line 8217\r\n   at VehicleAPI.VehicleGW.VehicleAPIPortTypeClient.updateVehicle(authentication authentication, gw_language gw_language, gw_locale gw_locale, String policyPeriodID, VehicleDTO vehicleDTO) in C:\\agent-win10\\_work\\73\\s\\PC\\VehicleAPI\\Service References\\VehicleGW\\Reference.cs:line 8228\r\n   at VehicleAPI.Models.VehicleManager.UpdateVehicle(String policyPeriodId, Vehicle vehicle) in C:\\agent-win10\\_work\\73\\s\\PC\\VehicleAPI\\Models\\VehicleManager.cs:line 731","ErrorLevel":2}]}');
        res.setStatusCode(404);
        return res;
    }
}