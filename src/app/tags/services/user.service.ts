import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { BehaviorSubject, catchError, firstValueFrom, Observable, of, tap } from 'rxjs';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { API_URL } from 'src/app/constants';
import { User } from '../models/user.model';
import { SpotifyUserLoginRequest, SpotifyUserLogResponse, UserRequest } from './user-interface';

@Injectable({
  providedIn: 'root'
})
export class UserService {


  private $currentUserSubject: BehaviorSubject<User | null>;
  public currentUser: Observable<User | null>;

  constructor(private http: HttpClient,
    private snackbar: MatSnackBar,
    private authService: AuthService
    ) {
      this.$currentUserSubject = new BehaviorSubject<User | null>(null);
      this.currentUser = this.$currentUserSubject.asObservable();
    }

    
    
  async getUser(userRequest: UserRequest): Promise<User> {
    const request = await this.authService.checkToken({jwt_token : userRequest.jwt_token})
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
      }),
      tap((res)=>this.$currentUserSubject.next(res))
      ),)
    return res;
  }

  logout(){
    this.$currentUserSubject.next(null);
  }

  async logInSpotifyUser(spotifyUserRequest: SpotifyUserLoginRequest): Promise<SpotifyUserLogResponse> {
    const request = await this.authService.checkToken({jwt_token : spotifyUserRequest.jwt_token})
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.post<SpotifyUserLogResponse>(API_URL + 'users/' + request.decoded.userId+"/spotify",spotifyUserRequest.spotifyUser, { headers: headers }, ).pipe(
      catchError(() => {
        this.snackbar.open('Login failure', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
        return of();
      }),),

    );
    return res;
  }

  async logoutSpotifyUser(spotifyUserRequest: UserRequest): Promise<SpotifyUserLogResponse> {
    const request = await this.authService.checkToken({jwt_token : spotifyUserRequest.jwt_token})
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.delete<SpotifyUserLogResponse>(API_URL + 'users/' + request.decoded.userId+"/spotify", { headers: headers }, ).pipe(
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
