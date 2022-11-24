// loader.component.ts

import { AfterViewInit, ChangeDetectorRef, Component, Input } from '@angular/core';
import { Subject, takeUntil } from 'rxjs';
import { LoaderService } from '../../services/loader.service';

@Component({
  selector: 'app-loader',
  templateUrl: './loader.component.html',
  styleUrls: ['./loader.component.scss'],
})
export class LoaderComponent implements AfterViewInit{
  @Input()
  isLoading  = false;

  destroyed$ = new Subject();

  constructor(private loaderService: LoaderService, private ref: ChangeDetectorRef) {
    
  }


  ngAfterViewInit(): void {
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
