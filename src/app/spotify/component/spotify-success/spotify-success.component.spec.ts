import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SpotifySuccessComponent } from './spotify-success.component';

describe('SpotifySuccessComponent', () => {
  let component: SpotifySuccessComponent;
  let fixture: ComponentFixture<SpotifySuccessComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SpotifySuccessComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SpotifySuccessComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
