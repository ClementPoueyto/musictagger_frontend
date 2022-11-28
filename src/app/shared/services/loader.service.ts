import { Injectable } from '@angular/core';
import {  BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class LoaderService {

  public loadingEvent : BehaviorSubject<boolean> = new BehaviorSubject(false);

  show() {
     this.loadingEvent.next(true);
  }

  hide() {
     this.loadingEvent.next(false);
  }
}
