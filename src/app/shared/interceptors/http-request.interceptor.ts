import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest, HttpStatusCode } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { MatSnackBar } from "@angular/material/snack-bar";
import { catchError, finalize, mergeMap, Observable } from "rxjs";
import { Token } from "src/app/authentication/services/auth-interfaces";
import { AuthService } from "src/app/authentication/services/auth.service";
import { environment } from "src/environments/environment";
import { LoaderService } from "../services/loader.service";
import { UserService } from "../services/user.service";

@Injectable()
export class HttpRequestInterceptor implements HttpInterceptor {

    constructor(private snackbar: MatSnackBar, private readonly authService: AuthService, private readonly userService: UserService, private loaderService : LoaderService) { }

    intercept(httpRequest: HttpRequest<any>, httpHandler: HttpHandler,): Observable<HttpEvent<any>> {
        if(!httpRequest.url.includes(environment.API_URL)){
            return this.requestHandler(httpRequest, httpHandler);
        }
        this.loaderService.show();
        if(httpRequest.url.includes('refresh-token')){
            return this.requestHandler(httpRequest, httpHandler);
        }
        return this.authService.getToken().pipe(mergeMap(
            (token: Token) => {
                if (token?.jwt_token) {
                    const jwt_token: string = token.jwt_token;
                    httpRequest = httpRequest.clone({
                        setHeaders: {
                            'Content-Type': 'application/json',
                            'Authorization': `Bearer ${jwt_token}`
                        }
                    });
                }
                const request =  this.requestHandler(httpRequest, httpHandler);
              
                return request;
            }
        ), );

    }

    private handleError(httpErrorResponse: HttpErrorResponse, httpRequest: HttpRequest<any>) {
        if(httpErrorResponse.status === HttpStatusCode.Unauthorized){
            this.userService.logout();
            this.authService.logout();
        }
        if(httpErrorResponse.status === 0){
            httpErrorResponse.error.message = 'Connection Refused'
        }
        console.log(httpErrorResponse)
        this.snackbar.open(httpErrorResponse.error.message, 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
        });
    }

    private requestHandler(httpRequest: HttpRequest<any>, httpHandler: HttpHandler): Observable<HttpEvent<any>> {
        return httpHandler.handle(httpRequest).pipe(
            catchError((httpErrorResponse: HttpErrorResponse) => {
                this.handleError(httpErrorResponse, httpRequest);
                throw httpErrorResponse;
            }), finalize(()=> {
                if(httpRequest.url.includes(environment.API_URL)){
                    this.loaderService.hide();
                }
            }));
    }

}