import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:barcode_image/barcode_image.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: QrGenerator(),
    );
  }
}

class QrGenerator extends StatefulWidget {
  const QrGenerator({super.key});

  @override
  QrGeneratorState createState() => QrGeneratorState();
}

class QrGeneratorState extends State<QrGenerator> {
  QrType type = QrType.link;
  QrOutputType outputType = QrOutputType.png;
  QrPngSize pngSize = QrPngSize.medium;
  int finalPngSize = 512;

  String textInput = '';
  Map<String, String> vcardForm = {'firstName': '', 'lastName': ''};

  int getSize() {
    switch (pngSize) {
      case QrPngSize.custom:
        return finalPngSize;
      case QrPngSize.medium:
        return 512;
      case QrPngSize.large:
        return 1024;
    }
  }

  void setQrType(QrType itemType) {
    setState(() {
      type = itemType;
    });
  }

  void calculateVcard() {
    // Add your vCard calculation logic here
  }

  Future<void> saveQrCode() async {
    final bc = Barcode.qrCode();

    if (outputType == QrOutputType.svg) {
      final svg = bc.toSvg(textInput);

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'output-file.svg',
      );

      if (outputFile != null) {
        await File(outputFile).writeAsString(svg);
      }
    } else if (outputType == QrOutputType.png) {
      final size = getSize();
      final image = img.Image(width: size, height: size);
      img.fill(image, color: img.ColorRgb8(255, 255, 255));
      drawBarcode(image, bc, textInput);

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'output-file.png',
      );

      if (outputFile != null) {
        await File(outputFile).writeAsBytes(img.encodePng(image));
      }
    } else {
      throw Exception('Invalid output type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(blurRadius: 10, color: Colors.black12)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'QRo',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Text('Um gerador pra gabi'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400.0,
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text('Tipo de QR Code',
                                  style: theme.textTheme.titleSmall),
                              Container(
                                margin: const EdgeInsets.only(top: 8.0),
                                child: SegmentedButton<QrType>(
                                  segments: const [
                                    ButtonSegment(
                                      value: QrType.link,
                                      label: Text('Link'),
                                      icon: Icon(Icons.link),
                                    ),
                                    ButtonSegment(
                                      value: QrType.text,
                                      label: Text('Texto'),
                                      icon: Icon(Icons.text_fields),
                                    ),
                                    ButtonSegment(
                                      value: QrType.vcard,
                                      label: Text('vCard'),
                                      icon: Icon(Icons.person),
                                    ),
                                  ],
                                  selected: <QrType>{type},
                                  onSelectionChanged: (value) {
                                    setQrType(value.first);
                                  },
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Text('Tipo de Saída',
                                  style: theme.textTheme.titleSmall),
                              Container(
                                margin: const EdgeInsets.only(top: 8.0),
                                child: SegmentedButton<QrOutputType>(
                                  segments: const [
                                    ButtonSegment(
                                      value: QrOutputType.png,
                                      label: Text('PNG'),
                                      icon: Icon(Icons.image),
                                    ),
                                    ButtonSegment(
                                      value: QrOutputType.svg,
                                      label: Text('SVG'),
                                      icon: Icon(Icons.image),
                                    ),
                                  ],
                                  selected: <QrOutputType>{outputType},
                                  onSelectionChanged: (value) {
                                    setState(() {
                                      outputType = value.first;
                                    });
                                  },
                                ),
                              ),
                              if (outputType == QrOutputType.png) ...[
                                const SizedBox(height: 16.0),
                                Text('Tamanho do PNG',
                                    style: theme.textTheme.titleSmall),
                                Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  child: SegmentedButton<QrPngSize>(
                                    segments: const [
                                      ButtonSegment(
                                        value: QrPngSize.custom,
                                        label: Text('Custom'),
                                        icon: Icon(Icons.image),
                                      ),
                                      ButtonSegment(
                                        value: QrPngSize.medium,
                                        label: Text('Médio'),
                                        icon: Icon(Icons.image),
                                      ),
                                      ButtonSegment(
                                        value: QrPngSize.large,
                                        label: Text('Grande'),
                                        icon: Icon(Icons.image),
                                      ),
                                    ],
                                    selected: <QrPngSize>{pngSize},
                                    onSelectionChanged: (value) {
                                      setState(() {
                                        pngSize = value.first;
                                      });
                                    },
                                  ),
                                ),
                                if (pngSize == QrPngSize.custom) ...[
                                  const SizedBox(height: 16.0),
                                  Text('Tamanho Personalizado',
                                      style: theme.textTheme.titleSmall),
                                  Container(
                                      margin: const EdgeInsets.only(top: 8.0),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            labelText: 'Tamanho'),
                                        onChanged: (value) {
                                          setState(() {
                                            finalPngSize = int.parse(value);
                                          });
                                        },
                                      )),
                                ],
                              ],
                            ],
                          ),
                          if (type == QrType.link) ...[
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Link'),
                              onChanged: (value) {
                                setState(() {
                                  textInput = value;
                                });
                              },
                            ),
                          ],
                          if (type == QrType.text) ...[
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Texto Bruto'),
                              onChanged: (value) {
                                setState(() {
                                  textInput = value;
                                });
                              },
                            ),
                          ],
                          if (type == QrType.vcard) ...[
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Primeiro Nome'),
                              onChanged: (value) {
                                setState(() {
                                  vcardForm['firstName'] = value;
                                  calculateVcard();
                                });
                              },
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Segundo Nome'),
                              onChanged: (value) {
                                setState(() {
                                  vcardForm['lastName'] = value;
                                  calculateVcard();
                                });
                              },
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Telefone'),
                              onChanged: (value) {
                                setState(() {
                                  // Update phone number in vCard form
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        children: [
                          BarcodeWidget(
                            barcode: Barcode.qrCode(),
                            data: textInput,
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: saveQrCode,
                            child: const Text('Salvar QR Code'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum QrPngSize { custom, medium, large }

enum QrOutputType { png, svg }

enum QrType { link, text, vcard }
