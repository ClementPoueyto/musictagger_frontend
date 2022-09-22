import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { JwtHelperService } from '@auth0/angular-jwt';
import { BehaviorSubject, catchError, firstValueFrom, Observable, of } from 'rxjs';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { API_URL } from 'src/app/constants';
import { SpotifyUser } from '../models/spotify-user.model';
import { User } from '../models/user.model';
import { SpotifyUserLoginRequest, SpotifyUserLoginResponse, UserRequest } from './user-interface';

@Injectable({
  providedIn: 'root'
})
export class UserService {


  user$ : BehaviorSubject<User | null> = new BehaviorSubject<User | null>(null)

  constructor(private http: HttpClient,
    private snackbar: MatSnackBar,
    private authService: AuthService
    ) { }

    
    
  async getUser(userRequest: UserRequest): Promise<User> {
    const request = await this.authService.checkToken({jwt_token : userRequest.jwt_token})
    console.log(request)
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<User>(API_URL + 'users/' + request.decoded.userId, { headers: headers }).pipe(
      catchError(() => {
        this.snackbar.open('Login failure', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
        return of();
      }),),

    );
    this.user$.next(res);
    return res;
  }

  async logInSpotifyUser(spotifyUserRequest: SpotifyUserLoginRequest): Promise<SpotifyUserLoginResponse> {
    const request = await this.authService.checkToken({jwt_token : spotifyUserRequest.jwt_token})
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.post<SpotifyUserLoginResponse>(API_URL + 'users/' + request.decoded.userId+"/spotify",spotifyUserRequest.spotifyUser, { headers: headers }, ).pipe(
      catchError(() => {
        this.snackbar.open('Login failure', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
        return of();
      }),),

    );
    return res;
  }

}
