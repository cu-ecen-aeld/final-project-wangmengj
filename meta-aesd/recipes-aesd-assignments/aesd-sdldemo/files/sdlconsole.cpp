#include <stdlib.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <iostream>

/*
 * A simple demo program to test if the platform support directfb and SDL in console
 * */
int main(int argc,  char** argv) 
{

    SDL_Window *win = NULL;
    SDL_Renderer *renderer = NULL;

    SDL_Init(SDL_INIT_TIMER | SDL_INIT_VIDEO);
    SDL_CreateWindowAndRenderer(
            800, 600,
            0, &win, &renderer
    );

    IMG_Init(IMG_INIT_PNG);

    SDL_Texture *texture = IMG_LoadTexture(renderer, argv[1]);
    std::cout << SDL_GetError();

    while (1) 
    {
        SDL_RenderCopy(renderer, texture, NULL, NULL);
        SDL_RenderPresent(renderer);

	SDL_Event e;
        if (SDL_PollEvent(&e))
        {
            sleep(2);
            break;
        }
    }

    SDL_DestroyTexture(texture);
    IMG_Quit();
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
}
