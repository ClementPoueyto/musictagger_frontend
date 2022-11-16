// loader.component.ts

import { AfterViewInit, ChangeDetectorRef, Component } from '@angular/core';
import { LoaderService } from '../../services/loader.service';

@Component({
  selector: 'app-loader',
  templateUrl: './loader.component.html',
  styleUrls: ['./loader.component.scss'],
})
export class LoaderComponent  implements AfterViewInit{
  isLoading : boolean = false;

  constructor(private loaderService: LoaderService, private ref: ChangeDetectorRef) {
   
  }
  ngAfterViewInit(): void {
    this.loaderService.loadingEvent.subscribe((res)=>{
      this.isLoading = res;
      this.ref.detectChanges();
    })
  }
}
