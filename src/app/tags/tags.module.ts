import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TagsRoutingModule } from './tags-routing.module';
import { SearchComponent } from './components/search/search.component';
import { AngularMaterialModule } from '../angular-material/angular-material.module';
import { SpotifyModule } from '../spotify/spotify.module';
import { MatDialog, MatDialogModule, MatDialogRef, MAT_DIALOG_DATA, MAT_DIALOG_DEFAULT_OPTIONS } from '@angular/material/dialog';
import { LoaderComponent } from './components/loader/loader.component';

import {
  HTTP_INTERCEPTORS,
  HttpClientModule,
} from '@angular/common/http';
import { LoaderInterceptor } from './interceptor/loader.interceptor';
import { TrackComponent } from './components/track/track.component';
import { FormsModule } from '@angular/forms';
import { FilterDialogComponent } from './components/search/filter-dialog/filter-dialog.component';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { DialogModule } from '@angular/cdk/dialog';


@NgModule({
  declarations: [
    SearchComponent,
    LoaderComponent,
    TrackComponent,
    FilterDialogComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    CommonModule,
    TagsRoutingModule,
    AngularMaterialModule,
    SpotifyModule,
    HttpClientModule,
    FormsModule,
    MatDialogModule,
  ],
  exports : [LoaderComponent,
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
