import { Component, OnInit } from '@angular/core';
import { tap } from 'rxjs/operators';
import { ActivatedRoute, Router } from '@angular/router';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { AuthService } from '../../services/auth.service';
import { DomSanitizer } from '@angular/platform-browser';
import { MatIconRegistry } from '@angular/material/icon';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { MatSnackBar } from '@angular/material/snack-bar';
import { JwtHelperService } from '@auth0/angular-jwt';
const googleLogoURL = 
"https://raw.githubusercontent.com/fireflysemantics/logo/master/Google.svg";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  loginForm: FormGroup = new FormGroup({
    email: new FormControl(null, [Validators.required, Validators.email]),
    password: new FormControl(null, [Validators.required]),
  });

  

  constructor(
    private authService: AuthService,
    private router: Router,
    private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer,
    private route: ActivatedRoute,
    private snackbar: MatSnackBar,
    private jwtService: JwtHelperService,

  ) { 
    this.matIconRegistry.addSvgIcon(
      "google-logo",
      this.domSanitizer.bypassSecurityTrustResourceUrl(googleLogoURL));
  }
  async ngOnInit(): Promise<void> {
    this.route.queryParams
      .subscribe(async params => {
        await this.isAlreadylogged();
        
        if(params["jwt"]){
          this.loginSuccess(params["jwt"]);
        }
        else if(params["failure"]){
          this.snackbar.open('Login failure : '+params["message"], 'Close', {
            duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
          });
        }
        
      } 
    );
  }

  isAlreadylogged(){
    const token = localStorage.getItem(LOCALSTORAGE_TOKEN_KEY);
    if(!token){
      return;
    }
    console.log(token)
      this.authService.refreshToken({jwt_token : token}).subscribe(
         tokenResponse =>{
          if(tokenResponse){
            this.router.navigate(['../tags'])
          }
        }
      )
      
    
  }

  loginSuccess(token : string){
    if(!this.jwtService.isTokenExpired(token)){
      localStorage.setItem(LOCALSTORAGE_TOKEN_KEY, token)
      this.snackbar.open('Login Successfull', 'Close', {
        duration: 2000, horizontalPosition: 'right', verticalPosition: 'top'
      });
      this.router.navigate(['../tags'])
    }
  }


  login() {
    if (!this.loginForm.valid) {
      return;
    }
    this.authService.login(this.loginForm.value).subscribe(
      res => {
        if(res){
          this.loginSuccess(res.jwt_token);
        }
      }
    );
  }


}
