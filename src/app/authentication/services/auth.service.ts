import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import {  Observable, tap,BehaviorSubject, of } from 'rxjs';
import { JwtHelperService } from '@auth0/angular-jwt';
import { LoginRequest, LoginResponse, RegisterRequest, RegisterResponse, Token } from './auth-interfaces';
import { LOCALSTORAGE_TOKEN_KEY, tokenGetter } from 'src/app/app.module';
import { Router } from '@angular/router';
import { CommonService } from 'src/app/shared/services/rest/common.service';


export enum AuthStatus{
  LOGIN, LOGOUT
}

@Injectable({
  providedIn: 'root'
})



export class AuthService extends CommonService{

  private currentAuthStatusSubject: BehaviorSubject<AuthStatus>;
  public currentAuthStatus: Observable<AuthStatus>;

  constructor(
    protected override http: HttpClient,
    protected jwtService: JwtHelperService,
    private router : Router
      ) {
    super(http);
    const token = tokenGetter()
    if(token){
      this.currentAuthStatusSubject = new BehaviorSubject<AuthStatus>(AuthStatus.LOGIN);
    }
    else{
      this.currentAuthStatusSubject = new BehaviorSubject<AuthStatus>(AuthStatus.LOGOUT);

    }
    this.currentAuthStatus = this.currentAuthStatusSubject.asObservable();
        
   }

  /*
   Due to the '/api' the url will be rewritten by the proxy, e.g. to http://localhost:8080/api/auth/login
   this is specified in the src/proxy.conf.json
   the proxy.conf.json listens for /api and changes the target. You can also change this in the proxy.conf.json
   The `..of()..` can be removed if you have a real backend, at the moment, this is just a faked response
  */
  login(loginRequest: LoginRequest): Observable<LoginResponse> {

    return this.http.post<LoginResponse>(this.apiConfiguration.api_url + 'auth', loginRequest).pipe(
      tap((res)=> {this.loginSuccess(res.jwt_token)})
    );
  }

  async logout(): Promise<void> {
    localStorage.removeItem(LOCALSTORAGE_TOKEN_KEY);
    this.currentAuthStatusSubject.next(AuthStatus.LOGOUT)
    this.router.navigate(['../']);

  }

  async loginSuccess(token : string) : Promise<void> {
    if(!await this.jwtService.isTokenExpired(token)){
      await localStorage.setItem(LOCALSTORAGE_TOKEN_KEY, token);
      this.currentAuthStatusSubject.next(AuthStatus.LOGIN);
      this.router.navigate(['tags']);
    }
  }

  /*
   The `..of()..` can be removed if you have a real backend, at the moment, this is just a faked response
  */
  register(registerRequest: RegisterRequest): Observable<RegisterResponse> {
    return this.http.post<RegisterResponse>(this.apiConfiguration.api_url + 'users', registerRequest)
  }

  /*
   Get the user fromt the token payload
   */
  getLoggedInUser() {
    const decodedToken = this.jwtService.decodeToken();
    return decodedToken.user;
  }

  refreshToken(): Observable<Token> {
    return this.http.get<Token>(this.apiConfiguration.api_url + 'auth/refresh-token',).pipe(
      tap((token) => localStorage.setItem(LOCALSTORAGE_TOKEN_KEY, token.jwt_token)
      ))
  }

  checkToken(checkTokenRequest: Token): Observable<Token> {
    if (this.jwtService.isTokenExpired(checkTokenRequest.jwt_token)) {
      return this.refreshToken();
    }
    else {
      return of({ jwt_token : checkTokenRequest.jwt_token });
    }
  }

  getToken() : Observable<Token>  {
    const currentToken = tokenGetter();
    if(currentToken){
      return this.checkToken({jwt_token : currentToken});
    }
    return of({jwt_token : ""});
  }
}
