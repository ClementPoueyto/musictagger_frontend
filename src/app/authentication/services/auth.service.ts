import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { firstValueFrom, map, Observable, of, tap,BehaviorSubject } from 'rxjs';
import { JwtHelperService } from '@auth0/angular-jwt';
import { MatSnackBar } from '@angular/material/snack-bar';
import { CheckTokenRequest, CheckTokenResponse, LoginRequest, LoginResponse, RefreshTokenRequest, RefreshTokenResponse, RegisterRequest, RegisterResponse } from './auth-interfaces';
import { catchError } from 'rxjs/operators';
import { API_URL } from 'src/app/constants';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { Router } from '@angular/router';

export enum AuthStatus{
  LOGIN, LOGOUT
}

@Injectable({
  providedIn: 'root'
})



export class AuthService {

  private currentAuthStatusSubject: BehaviorSubject<AuthStatus>;
    public currentAuthStatus: Observable<AuthStatus>;

  constructor(
    private http: HttpClient,
    private snackbar: MatSnackBar,
    private jwtService: JwtHelperService,
    private router : Router
  ) {
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
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

    return this.http.post<LoginResponse>(API_URL + 'auth', loginRequest).pipe(
      catchError(() => {
        this.snackbar.open('Login failure', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
        return of()
      }),
      tap((res)=> {this.loginSuccess(res.jwt_token)})

    );
  }

  async logout(): Promise<void> {
    localStorage.removeItem(LOCALSTORAGE_TOKEN_KEY);
    this.currentAuthStatusSubject.next(AuthStatus.LOGOUT)
    this.router.navigate(['../login']);

  }

  loginSuccess(token : string) : void {
    if(!this.jwtService.isTokenExpired(token)){
      localStorage.setItem(LOCALSTORAGE_TOKEN_KEY, token)
      this.currentAuthStatusSubject.next(AuthStatus.LOGIN);
      this.snackbar.open('Login Successfull', 'Close', {
        duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
      });
      this.router.navigate(['../tags']);

    }
  }

  /*
   The `..of()..` can be removed if you have a real backend, at the moment, this is just a faked response
  */
  register(registerRequest: RegisterRequest): Observable<RegisterResponse> {

    return this.http.post<RegisterResponse>(API_URL + 'users', registerRequest).pipe(
      catchError(() => {
        this.snackbar.open('create user failure', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
        return of()
      }),
      tap((res: RegisterResponse) => this.snackbar.open(`User created successfully`, 'Close', {
        duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
      }))
    )
  }

  /*
   Get the user fromt the token payload
   */
  getLoggedInUser() {
    const decodedToken = this.jwtService.decodeToken();
    return decodedToken.user;
  }

  refreshToken(refreshTokenRequest: RefreshTokenRequest): Observable<RefreshTokenResponse> {
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${refreshTokenRequest.jwt_token}`
    })
    return this.http.get<RefreshTokenResponse>(API_URL + 'auth/refresh-token', { headers: headers }).pipe(
      catchError(() => {
        this.snackbar.open('invalid jwt token', 'Close', {
          duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
        return of()
      }),
      tap((token) => localStorage.setItem(LOCALSTORAGE_TOKEN_KEY, token.jwt_token)
      ))
  }

  async checkToken(checkTokenRequest: CheckTokenRequest): Promise<CheckTokenResponse> {
    if (this.jwtService.isTokenExpired(checkTokenRequest.jwt_token)) {
      const new_token = await firstValueFrom(this.refreshToken({ jwt_token: checkTokenRequest.jwt_token }))
      return {
        token: new_token.jwt_token,
        decoded: this.jwtService.decodeToken(new_token.jwt_token)
      }
    }
    else {
      return {
        token: checkTokenRequest.jwt_token,
        decoded: this.jwtService.decodeToken(checkTokenRequest.jwt_token)
      }
    }

  }
}
