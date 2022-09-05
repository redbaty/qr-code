import {Component} from '@angular/core';

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

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  public textInput = '';

  public widthChoice: Choice = new Choice(256, [-1, 256, 512], false);

  public marginChoice: Choice = new Choice(
    5,
    [-1, 5, 0, 10, 20],
    false
  );

  saveAsImage(parent: any) {
    let parentElement: null


    parentElement = parent.qrcElement.nativeElement
      .querySelector("canvas")
      .toDataURL("image/png");

    if (parentElement) {


      // converts base 64 encoded image to blobData
      let blobData = this.convertBase64ToBlob(parentElement)
      // saves as image
      const blob = new Blob([blobData], {type: "image/png"})
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
    return new Blob([uInt8Array], {type: imageType})
  }

  setWidth(item: number) {
    this.widthChoice.set(item);
  }

  setMargin(item: number) {
    this.marginChoice.set(item);
  }
}
