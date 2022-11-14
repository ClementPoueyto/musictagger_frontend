import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Inject, Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { BehaviorSubject, catchError, EMPTY, firstValueFrom, Observable, of, tap } from 'rxjs';
import { AuthService } from 'src/app/authentication/services/auth.service';
import { CommonAuthService } from 'src/app/core/services/rest/common-auth.service';
import { User } from '../models/user.model';
import { SpotifyUserLoginRequest, SpotifyUserLogResponse, UserRequest } from './user-interface';

@Injectable({
  providedIn: 'root'
})
export class UserService extends CommonAuthService {


  private $currentUserSubject: BehaviorSubject<User | null>;
  public currentUser: Observable<User | null>;

  constructor(protected override http: HttpClient,
    protected override authService: AuthService
  ) {
    super(http, authService);
    this.$currentUserSubject = new BehaviorSubject<User | null>(null);
    this.currentUser = this.$currentUserSubject.asObservable();
  }



  async getUser(userRequest: UserRequest): Promise<User> {
    const request = await this.authService.checkToken({ jwt_token: userRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.get<User>(this.apiConfiguration.api_url + 'users/' + request.decoded.userId, { headers: headers }).pipe(
      tap((res) => this.$currentUserSubject.next(res))
    ),)
    return res;
  }

  logout() {
    this.$currentUserSubject.next(null);
  }

  async logInSpotifyUser(spotifyUserRequest: SpotifyUserLoginRequest): Promise<SpotifyUserLogResponse> {
    const request = await this.authService.checkToken({ jwt_token: spotifyUserRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })

    const res = await firstValueFrom(this.http.post<SpotifyUserLogResponse>(this.apiConfiguration.api_url + 'users/' + request.decoded.userId + "/spotify", spotifyUserRequest.spotifyUser, { headers: headers },)

    );
    return res;
  }

  async logoutSpotifyUser(spotifyUserRequest: UserRequest): Promise<SpotifyUserLogResponse> {
    const request = await this.authService.checkToken({ jwt_token: spotifyUserRequest.jwt_token })
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${request.token}`
    })
    const res = await firstValueFrom(this.http.delete<SpotifyUserLogResponse>(this.apiConfiguration.api_url + 'users/' + request.decoded.userId + "/spotify", { headers: headers },)
    );
    return res;
  }

}
