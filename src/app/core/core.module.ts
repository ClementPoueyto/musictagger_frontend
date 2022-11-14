import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { HttpRequestInterceptor } from './interceptors/http-request.interceptor';
import { CommonService } from './services/rest/common.service';
import { CommonAuthService } from './services/rest/common-auth.service';



@NgModule({
  declarations: [],
  imports: [
    CommonModule
  ],
  providers : [
    {provide: HTTP_INTERCEPTORS,
    useClass: HttpRequestInterceptor,
    multi: true},
    CommonService,
    CommonAuthService
  ]
})
export class CoreModule { }
