import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentremedy_mobile/Model/Maintenance/maintenance_request.dart';
import 'package:rentremedy_mobile/Providers/api_service_provider.dart';
import 'package:rentremedy_mobile/View/Maintenance/view_maintenance_request_screen.dart';

class ViewMaintenanceRequestsScreen extends StatefulWidget {
  const ViewMaintenanceRequestsScreen({Key? key}) : super(key: key);

  @override
  _ViewMaintenanceRequestsScreenState createState() =>
      _ViewMaintenanceRequestsScreenState();
}

class _ViewMaintenanceRequestsScreenState
    extends State<ViewMaintenanceRequestsScreen>
    with AutomaticKeepAliveClientMixin<ViewMaintenanceRequestsScreen> {
  late ApiServiceProvider apiService;

  late List<MaintenanceRequest> maintenanceRequests;
  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = Provider.of<ApiServiceProvider>(context, listen: false);
    maintenanceRequests = [];
    fetchPayments();
  }

  Future fetchPayments() async {
    List<MaintenanceRequest> maintenanceRequestList =
        await apiService.getAllMaintenanceRequests();
    if (mounted) {
      setState(() {
        maintenanceRequests = maintenanceRequestList;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/maintenanceRequest');
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add)),
            body: Column(children: [
              if (maintenanceRequests != null) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                      child: ListView.builder(
                          itemCount: maintenanceRequests.length,
                          itemBuilder: (context, index) =>
                              MaintenanceRequestItem(
                                  maintenanceRequest:
                                      maintenanceRequests[index])),
                      onRefresh: fetchPayments,
                    ),
                  ),
                ),
              ] else ...[
                const Center(child: Text("No maintenance requests yet"))
              ],
            ]),
          )
        : const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  @override
  bool get wantKeepAlive => true;
}

class MaintenanceRequestItem extends StatelessWidget {
  MaintenanceRequest maintenanceRequest;
  MaintenanceRequestItem({Key? key, required this.maintenanceRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(maintenanceRequest.item),
      subtitle: Text('Status: ${maintenanceRequest.status.name}'),
      onTap: () {
        Navigator.pushNamed(context, '/viewMaintenanceRequest',
            arguments:
                ViewMaintenanceRequestScreenArguments(maintenanceRequest));
      },
    ));
  }
}
