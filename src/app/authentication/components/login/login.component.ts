import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { AuthService } from '../../services/auth.service';
import { DomSanitizer } from '@angular/platform-browser';
import { MatIconRegistry } from '@angular/material/icon';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { MatSnackBar } from '@angular/material/snack-bar';
import { JwtHelperService } from '@auth0/angular-jwt';
import {Subscription, firstValueFrom} from 'rxjs';


const googleLogoURL = 
"https://raw.githubusercontent.com/fireflysemantics/logo/master/Google.svg";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit, OnDestroy {

  loginForm: FormGroup = new FormGroup({
    email: new FormControl(null, [Validators.required, Validators.email]),
    password: new FormControl(null, [Validators.required]),
  });

  routeSub : Subscription = new Subscription();

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
  ngOnDestroy(): void {
    this.routeSub.unsubscribe();
  }
  async ngOnInit(): Promise<void> {
    this.routeSub = this.route.queryParams
      .subscribe(async params => {
        await this.isAlreadylogged();
        
        if(params["jwt"]){
          this.authService.loginSuccess(params["jwt"]);
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
      firstValueFrom(this.authService.refreshToken({jwt_token : token})).then(tokenResponse=>{
        if(tokenResponse) this.router.navigate(['../tags'])
      }   )          
  }



  login() {
    if (!this.loginForm.valid) {
      return;
    }
    firstValueFrom(this.authService.login(this.loginForm.value));
  }


}
