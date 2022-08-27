import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/screens/resevation_payment_screen.dart';
import 'package:massageapp/widgets/widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BookingScreen extends StatefulWidget {
  static const String routeName = "booking-screen";
  final Shop shop;

  const BookingScreen({Key? key, required this.shop}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final GlobalKey<FormState> _bookingFormKey = GlobalKey<FormState>();
  String _dateRange = "";
  final TextEditingController _clientsController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _timeController = TextEditingController();
  bool _processing = false;

  selectDateRange(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('select date'),
            content: Container(
              height: 300,
              width: 300,
              child: SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 30)),
                    (DateTime.now().add(const Duration(days: 1)))),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    String dateRg = "";
    if (args.value is PickerDateRange) {
      dateRg =
          DateFormat('yyyy/MM/dd').format(args.value.startDate).toString() +
              ' - ' +
              DateFormat('yyyy/MM/dd')
                  .format(args.value.endDate ?? args.value.startDate)
                  .toString();
    } else if (args.value is DateTime) {
      dateRg = args.value.toString();
    } else if (args.value is List<DateTime>) {
      dateRg = args.value.length.toString();
    } else {
      dateRg = args.value.length.toString();
    }
    setState(() {
      _dateRange = dateRg;
    });
  }

  showTimeRangePicker() async {
    final time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      _timeController.text = '${time.hour}:${time.minute}:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: MyAppBar(
        null,
        title: Text(widget.shop.name),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _bookingFormKey,
          child: Column(
            children: [
              SingleBanner(shop: widget.shop),
              InputSpacer(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: InkWell(
                    onTap: () {
                      selectDateRange(context);
                    },
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            child: Text(_dateRange == ""
                                ? "\t\t${translator.selectDate}"
                                : _dateRange),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              selectDateRange(context);
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).primaryColor,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              InputSpacer(
                  child: InkWell(
                onTap: showTimeRangePicker,
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextFormField(
                    controller: _timeController,
                    validator: (e) => InputValidators.validateNoEmpty(
                        e, 1, '${translator.visiting} ${translator.time}'),
                    decoration: InputDecoration(
                        label:
                            Text('${translator.visiting} ${translator.time}'),
                        border: OutlineInputBorder()),
                  ),
                ),
              )),
              InputSpacer(
                  child: DropdownSearch<int>(
                maxHeight: 250,
                //ignore:deprecated_member_use
                label: translator.noOfPeople,
                mode: Mode.MENU,
                items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                itemAsString: (s) => s.toString(),
                validator: (v) => v == null ? translator.required : null,
                onChanged: (e) {
                  setState(() {
                    _clientsController.text = e.toString();
                  });
                },
              )),
              InputSpacer(
                  child: TextFormField(
                controller: _phoneNumberController,
                validator: InputValidators.validatePhoneNumber,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '${translator.phone} ${translator.number}'),
              )),
              InputSpacer(
                child: InputButton(
                    state: !_processing,
                    onPressed: () async {
                      if (_bookingFormKey.currentState!.validate()) {
                        if (_dateRange == "") {
                          showErrorToasts(translator.reservation +
                              ' ' +
                              translator.required);
                        } else {
                          if (mounted) {
                            setState(() {
                              _processing = true;
                            });
                          }
                          BookingModel book = BookingModel(
                              status: 0,
                              visitingTime: _timeController.text,
                              startingDate: _dateRange.split("-")[0],
                              massageShopId: widget.shop.id,
                              phoneNumber: _phoneNumberController.text,
                              endingDate: _dateRange.split("-")[1],
                              noOfClients: _clientsController.text,
                              bookedUser: authController.currentUser.value);

                          final bookId =
                              await bookingController.makeABooking(book);
                          if (mounted) {
                            setState(() {
                              _processing = false;
                            });
                          }
                          widget.shop.bookingId = bookId;
                          await Navigator.of(context).pushNamed(
                              ReservationPaymentScreen.routeName,
                              arguments: widget.shop);
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    buttonText: translator.bookNow),
              )
            ],
          ),
        ),
      ),
    );
  }
}
