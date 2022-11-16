import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { JwtHelperService } from '@auth0/angular-jwt';
import { BehaviorSubject, firstValueFrom, Observable, tap } from 'rxjs';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { User } from '../models/user.model';
import { CommonService } from './rest/common.service';
import { SpotifyUserLoginRequest, SpotifyUserLogResponse, UserRequest } from './user-interface';

@Injectable({
  providedIn: 'root'
})
export class UserService extends CommonService {


  private $currentUserSubject: BehaviorSubject<User | null>;
  public currentUser: Observable<User | null>;
  protected userId : string | null = null;

  constructor(protected override http: HttpClient, private jwtService : JwtHelperService
  ) {
    super(http);
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if(token){
      const decoded = this.jwtService.decodeToken(token);
      this.userId = decoded.userId;
    }
    this.$currentUserSubject = new BehaviorSubject<User | null>(null);
    this.currentUser = this.$currentUserSubject.asObservable();
    this.currentUser.subscribe(
      (user)=>{
        if(user){
          this.userId = user.id
        }
      }
    )
  
  }



  async getUser(userRequest?: UserRequest): Promise<User> {
    let userId = this.userId;
    if(userRequest?.userId){
      userId = userRequest.userId;
    }
    const res = await firstValueFrom(this.http.get<User>(this.apiConfiguration.api_url + 'users/' + userId).pipe(
      tap((res) => this.$currentUserSubject.next(res))
    ),)
    console.log(res)
    return res;
  }

  getUserId(){
    return this.userId;
  }

  logout() {
    this.$currentUserSubject.next(null);
  }

  async logInSpotifyUser(spotifyUserRequest: SpotifyUserLoginRequest): Promise<SpotifyUserLogResponse> {


    const res = await firstValueFrom(this.http.post<SpotifyUserLogResponse>(this.apiConfiguration.api_url + 'users/' + this.userId + "/spotify", spotifyUserRequest.spotifyUser,)

    );
    return res;
  }

  async logoutSpotifyUser(spotifyUserRequest: UserRequest): Promise<SpotifyUserLogResponse> {

    const res = await firstValueFrom(this.http.delete<SpotifyUserLogResponse>(this.apiConfiguration.api_url + 'users/' + this.userId + "/spotify",)
    );
    return res;
  }

}
