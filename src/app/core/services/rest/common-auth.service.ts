import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { CommonService } from './common.service';

@Injectable({
  providedIn: 'root'
})
export class CommonAuthService extends CommonService {

  constructor(protected override readonly http: HttpClient, protected readonly authService: AuthService) {
    super(http);
  }
}
