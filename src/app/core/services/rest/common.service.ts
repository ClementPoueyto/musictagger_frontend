import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { environment } from 'src/environments/environment';
import { IApiConfiguration } from '../../models/api-configuration.model';

@Injectable({
  providedIn: 'root'
})
export class CommonService {

  apiConfiguration: IApiConfiguration;

  constructor(protected http: HttpClient) {
    this.apiConfiguration = {
      api_url: environment.API_URL
    };
  }
}
