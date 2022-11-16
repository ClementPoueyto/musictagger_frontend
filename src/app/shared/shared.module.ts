import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AngularMaterialModule } from './angular-material/angular-material.module';
import { LoaderService } from './services/loader.service';
import { CommonService } from './services/rest/common.service';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { HttpRequestInterceptor } from './interceptors/http-request.interceptor';
import { LoaderComponent } from './components/loader/loader.component';



@NgModule({
  declarations: [LoaderComponent],
  imports: [
    CommonModule,
    AngularMaterialModule
  ],
  providers:[
    LoaderService,
    CommonService,

    {
      provide: HTTP_INTERCEPTORS,
      useClass: HttpRequestInterceptor,
      multi: true
    },
  ],
  exports: [
    AngularMaterialModule,
    LoaderComponent
  ]
})
export class SharedModule { }
