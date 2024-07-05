import { Component, ViewChild } from '@angular/core';
import { QRCodeComponent } from 'angularx-qrcode';
import { EmailProperty, FNProperty, NProperty, SpecialValueType, TelProperty, TextType, VCARD } from "vcard4";

class Choice {
  constructor(public value: number, public choices: number[], public custom: boolean) {
  }

  set(newValue: number) {
    if (newValue < 0) {
      this.custom = true;
    } else {
      this.value = newValue;
      this.custom = false;
    }
  }
}

enum QrType {
  link = 'link',
  text = 'text',
  vcard = 'vcard'
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  public textInput = '';

  public vcardInput = '';

  public type: QrType = QrType.link;

  public widthChoice: Choice = new Choice(256, [-1, 256, 512], false);

  public marginChoice: Choice = new Choice(
    5,
    [-1, 5, 0, 10, 20],
    false
  );

  public colorLight: string = '#EEEEEE';

  public useSvg: boolean = false;

  public showVcardOutput: boolean = false;

  public vcardForm: {
    firstName: string,
    lastName: string,
    phone: string,
    email: string
  } = {
      firstName: '',
      lastName: '',
      phone: '',
      email: ''
    };

  public vcard: undefined | VCARD;

  calculateVcard() {

    if (this.vcardForm.firstName == '' && this.vcardForm.lastName == '') {
      this.vcard = undefined;
      this.textInput = '';
    }

    const nameArray = Array(5);

    if (this.vcardForm.firstName && this.vcardForm.firstName != null)
      nameArray[0] = new TextType(this.vcardForm.firstName);

    if (this.vcardForm.lastName && this.vcardForm.lastName != null)
      nameArray[1] = new TextType(this.vcardForm.lastName);

    let ar = [
      new FNProperty([], new TextType(`${this.vcardForm.firstName} ${this.vcardForm.lastName}`)),
      new NProperty([], new SpecialValueType("NProperty", nameArray))
    ];


    if (this.vcardForm.phone && this.vcardForm.phone != null)
      ar.push(new TelProperty([], new TextType(this.vcardForm.phone)));

    if (this.vcardForm.email && this.vcardForm.email != null)
      ar.push(new EmailProperty([], new TextType(this.vcardForm.email)));

    this.vcard = new VCARD(ar);
    this.textInput = this.vcard.repr();
  }

  saveAsSvg(parent: QRCodeComponent) {
    const svg = parent.qrcElement.nativeElement
      .querySelector("svg")
      .outerHTML;

    const blob = new Blob([svg.toString()]);
    const element = document.createElement("a");
    element.download = "qr.svg";
    element.href = window.URL.createObjectURL(blob);
    element.click();
    element.remove();
  }

  saveAsImage(parent: QRCodeComponent) {
    let parentElement: null

    parentElement = parent.qrcElement.nativeElement
      .querySelector("canvas")
      .toDataURL("image/png");

    if (parentElement) {
      // converts base 64 encoded image to blobData
      let blobData = this.convertBase64ToBlob(parentElement)
      // saves as image
      const blob = new Blob([blobData], { type: "image/png" })
      const url = window.URL.createObjectURL(blob)
      const link = document.createElement("a")
      link.href = url
      // name of the file
      link.download = "Qrcode"
      link.click()
    }
  }

  private convertBase64ToBlob(Base64Image: string) {
    // split into two parts
    const parts = Base64Image.split(";base64,")
    // hold the content type
    const imageType = parts[0].split(":")[1]
    // decode base64 string
    const decodedData = window.atob(parts[1])
    // create unit8array of size same as row data length
    const uInt8Array = new Uint8Array(decodedData.length)
    // insert all character code into uint8array
    for (let i = 0; i < decodedData.length; ++i) {
      uInt8Array[i] = decodedData.charCodeAt(i)
    }
    // return blob image after conversion
    return new Blob([uInt8Array], { type: imageType })
  }

  setWidth(item: number) {
    this.widthChoice.set(item);
  }

  setMargin(item: number) {
    this.marginChoice.set(item);
  }

  setQrType(t: string) {
    this.type = t as QrType;
  }

  protected readonly Object = Object;
  protected readonly QrType = QrType;
}
