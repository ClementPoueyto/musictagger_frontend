import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { TagsRoutingModule } from './tags-routing.module';
import { SearchComponent } from './components/search/search.component';
import { AngularMaterialModule } from '../angular-material/angular-material.module';
import { HomeComponent } from './components/home/home.component';
import { NavbarComponent } from './components/navbar/navbar.component';
import { HttpClientModule } from '@angular/common/http';
import { AuthenticationModule } from '../authentication/authentication.module';


@NgModule({
  declarations: [
    SearchComponent,
    HomeComponent,
    NavbarComponent
    ],
  imports: [
    CommonModule,
    TagsRoutingModule,
    AngularMaterialModule,
    HttpClientModule,
    AuthenticationModule
  ]
  
})
export class TagsModule { }
