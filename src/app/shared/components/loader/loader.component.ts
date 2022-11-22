// loader.component.ts

import { AfterViewInit, ChangeDetectorRef, Component } from '@angular/core';
import { Subject, takeUntil } from 'rxjs';
import { LoaderService } from '../../services/loader.service';

@Component({
  selector: 'app-loader',
  templateUrl: './loader.component.html',
  styleUrls: ['./loader.component.scss'],
})
export class LoaderComponent{
  isLoading : boolean = false;

  destroyed$ = new Subject();

  constructor(private loaderService: LoaderService, private ref: ChangeDetectorRef) {
    this.loaderService.loadingEvent.pipe(takeUntil(this.destroyed$)).subscribe((res)=>{
      this.isLoading = res;
      this.ref.detectChanges();
    });
  }


  ngOnDestroy() {
    this.destroyed$.next(true);
    this.destroyed$.complete();
  }
}
