import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TagsRoutingModule } from './tags-routing.module';
import { SearchComponent } from './components/search/search.component';
import { SpotifyModule } from '../spotify/spotify.module';
import { MatDialogModule } from '@angular/material/dialog';
import { LoaderComponent } from './components/loader/loader.component';

import {
  HttpClientModule,
} from '@angular/common/http';
import { LoaderInterceptor } from './interceptor/loader.interceptor';
import { TrackComponent } from './components/track/track.component';
import { FormsModule } from '@angular/forms';
import { FilterDialogComponent } from './components/search/filter-dialog/filter-dialog.component';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { SharedModule } from '../shared/shared.module';


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
    SpotifyModule,
    HttpClientModule,
    FormsModule,
    MatDialogModule,
    SharedModule
  ],
  exports: [LoaderComponent,
  ],




})
export class TagsModule { }
