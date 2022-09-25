import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TagsRoutingModule } from './tags-routing.module';
import { SearchComponent } from './components/search/search.component';
import { AngularMaterialModule } from '../angular-material/angular-material.module';
import { SpotifyModule } from '../spotify/spotify.module';
import { MatDialogModule } from '@angular/material/dialog';
import { LoaderComponent } from './components/loader/loader.component';

import {
  HTTP_INTERCEPTORS,
  HttpClientModule,
} from '@angular/common/http';
import { LoaderInterceptor } from './interceptor/loader.interceptor';
import { TrackComponent } from './components/track/track.component';


@NgModule({
  declarations: [
    SearchComponent,
    LoaderComponent,
    TrackComponent
  ],
  imports: [
    CommonModule,
    TagsRoutingModule,
    AngularMaterialModule,
    SpotifyModule,
    HttpClientModule,
    MatDialogModule

  ],
  providers: [
    {
       provide: HTTP_INTERCEPTORS,
       useClass: LoaderInterceptor,
       multi: true,
    },
 ],
  
  
})
export class TagsModule { }
