import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:barcode_image/barcode_image.dart';
import 'package:image/image.dart' as img;
import 'package:vcard_maintained/vcard_maintained.dart';

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

class QrCodeViewSettings {
  final bool show;
  final int size;

  QrCodeViewSettings({required this.show, required this.size});
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

  final _formKey = GlobalKey<FormState>();
  final vCard = VCard();

  final _customSizeController = TextEditingController();

  String textInput = '';

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

  QrCodeViewSettings getQrCodeViewSettings(MediaQueryData mediaQuery) {
    final show = mediaQuery.size.width > 600;
    final calculatedSize = getSize();
    final size = calculatedSize > 400 ? 400 : calculatedSize;

    return QrCodeViewSettings(show: show, size: size);
  }

  @override
  void dispose() {
    _customSizeController.dispose();
    super.dispose();
  }

  void setQrType(QrType itemType) {
    setState(() {
      type = itemType;
    });
  }

  void calculateVcard() {
    textInput = vCard.getFormattedString();
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
    final mediaQuery = MediaQuery.of(context);
    final qrCodeViewSettings = getQrCodeViewSettings(mediaQuery);

    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'QRo',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const Text('Um gerador pra gabi'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 600.0,
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
                                  Card(
                                    color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          if (type == QrType.link ||
                                              type == QrType.text) ...[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text('Texto do QR Code',
                                                  style: theme
                                                      .textTheme.titleSmall),
                                            ),
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  maxHeight: 200),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: TextFormField(
                                                  maxLines: type == QrType.text
                                                      ? null
                                                      : 1,
                                                  decoration: InputDecoration(
                                                      hintText: type ==
                                                              QrType.link
                                                          ? 'https://example.com'
                                                          : 'Texto'),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Por favor, insira um valor';
                                                    }

                                                    if (type == QrType.link &&
                                                        !Uri.tryParse(value)!
                                                            .isAbsolute) {
                                                      return 'Por favor, insira um link válido';
                                                    }

                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        textInput = value;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                          if (type == QrType.vcard) ...[
                                            Wrap(
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              children: [
                                                TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          icon: Icon(Icons
                                                              .badge_outlined),
                                                          labelText: 'Nome'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      vCard.firstName = value;
                                                      calculateVcard();
                                                    });
                                                  },
                                                ),
                                                TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Sobrenome',
                                                    icon: Icon(
                                                        Icons.person_outline),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      vCard.lastName = value;
                                                      calculateVcard();
                                                    });
                                                  },
                                                ),
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Telefone',
                                                    icon: Icon(
                                                        Icons.phone_outlined),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Por favor, insira um valor';
                                                    }

                                                    const phoneRegex =
                                                        r'^\+?[\d\s-]+$';
                                                    if (!RegExp(phoneRegex)
                                                        .hasMatch(value)) {
                                                      return 'Por favor, insira um telefone válido';
                                                    }

                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        vCard.cellPhone = value;
                                                        calculateVcard();
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
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
                                            label: Text('Médio (512px)'),
                                            icon: Icon(Icons.image),
                                          ),
                                          ButtonSegment(
                                            value: QrPngSize.large,
                                            label: Text('Grande (1024px)'),
                                            icon: Icon(Icons.image),
                                          ),
                                        ],
                                        selected: <QrPngSize>{pngSize},
                                        onSelectionChanged: (value) {
                                          final localPngSize = value.first;

                                          if (localPngSize ==
                                              QrPngSize.custom) {
                                            _customSizeController.text =
                                                finalPngSize.toString();
                                          }

                                          setState(() {
                                            pngSize = value.first;
                                            finalPngSize = getSize();
                                          });
                                        },
                                      ),
                                    ),
                                    if (pngSize == QrPngSize.custom) ...[
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText: 'Tamanho Customizado',
                                            suffix: Text('px')),
                                        controller: _customSizeController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, insira um valor';
                                          }

                                          if (int.tryParse(value) == null) {
                                            return 'Por favor, insira um valor válido';
                                          }

                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final asInt = int.tryParse(value);

                                            if (asInt != null) {
                                              setState(() {
                                                finalPngSize = asInt;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 16.0),
                                    ],
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            children: [
                              if (qrCodeViewSettings.show)
                                BarcodeWidget(
                                  barcode: Barcode.qrCode(),
                                  data: textInput,
                                  width: qrCodeViewSettings.size.toDouble(),
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
        ),
      ),
    );
  }
}

enum QrPngSize { custom, medium, large }

enum QrOutputType { png, svg }

enum QrType { link, text, vcard }
