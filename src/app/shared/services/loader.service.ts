import { EventEmitter, Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { CommonService } from './rest/common.service';

@Injectable({
  providedIn: 'root',
})
export class LoaderService {

  public loadingEvent : Subject<boolean>;

  constructor(){
    this.loadingEvent = new Subject();
  }
  show() {
     this.loadingEvent.next(true);
  }

  hide() {
     this.loadingEvent.next(false);
  }
}
