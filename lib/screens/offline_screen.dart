import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'You Are Offline!',
              style: TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 255, 191, 0),
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Make sure You have better network connection.',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(29),
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 255, 174, 0),
                  Color.fromARGB(255, 255, 238, 0)
                ]),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(34.0),
                  ),
                  primary: Colors.transparent,
                  onSurface: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  ' CLOSE ',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
