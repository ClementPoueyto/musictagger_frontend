import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SpotifyFailureComponent } from './spotify-failure.component';

describe('SpotifyFailureComponent', () => {
  let component: SpotifyFailureComponent;
  let fixture: ComponentFixture<SpotifyFailureComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SpotifyFailureComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SpotifyFailureComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
