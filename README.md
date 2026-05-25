# Comet Cafe

A game design project for CSC 468B

Created by: AJ, Carol, Connor, Jerome, and Robert

This was originally a private git repository, so I had to copy it over, and as such, not all of the files are in the right places. Regardless, this is all of the assets, scripts, etc from that project.

## Dependencies
- Godot 4.5.1 (Can be installed through Steam, or downloaded from https://godotengine.org/download/)
- Git and [Git LFS](https://git-lfs.com/)

## Getting Started
1. Install all dependencies
2. Clone the project through your prefered Git program such as [Github Desktop](https://desktop.github.com/download/), or if you are using the cli then run `git clone https://github.com/V-rtualized/comet-cafe.git`
3. Open Godot > Import > Find the project files > Import
4. Do not make any changes, unless you are on your own feature branch as described below

## Things to keep in mind
- Godot really does not like when you update certain files while the project is open. Before you pull from github ensure you close the godot project and then re-open it to prevent any issues.
- To keep our project from having frequent merge conflicts we will be using different branches for different people or features.

## When you start work on a feature
1. Create a new branch called `your-name/feature-name`, or alternative you are free to just work on a single branch called `your-name` throughout the whole semester if you prefer.
2. All your changes should only exist within this branch
    - It is a good idea to occasionally merge the `main` branch into your branch to keep updated with the other changes and features happening in the project.
    - Although, if you fear merge problems then you don't need to worry about this
3. Once your feature is complete, make sure to push all your changes so they exist on github and not just on your computer
4. Create a pull request with your feature, let me know if you don't know how to do this
   - (Optional) In your pull request you can request a review from me, this will just send me a notification that you are waiting for review but I will get to it either way
   - I will review your pull request, ensure everything works with the rest of the project, and then merge your code into the `main` branch
   - At this point, if you are using a `your-name/feature-name` branch, then the branch can be archived or deleted and you can start on a fresh branch
   - Otherwise, if you are using a `your-name` branch you should pull all changes from `main` and ensure it is exactly the same as the `main` branch before continuing
  
## When you are submitting art assets to be used
You should be following the process above, even if you are just adding or changing assets. This is because Godot keeps a seperate "metadata" file that corrosponds to all other assets, scripts, gameobjects, etc. within the engine. This metadata file provides an ID and other properties to each asset. If you add, remove, or replace assets outside of Godot then Godot can get confused and break other parts of the project that relied on that asset ID. So, we add assets through Godot to allow Godot to create a consistent metadata for everyone to use (if you add it outside of Godot then different people might make different metadata files for the same asset on different feature branches which will cause chaos). If you are removing or replacing an asset make sure to also do that in Godot, so that it can handle the data changes properly. Asset updates won't work 100% of the time, you may break a few gameobjects or sprites (visually) but as long as you did the update through Godot then it is easily fixable, just mention that it broke x and y feature/mechanic/object in your Pull Request and I can go in and fix it.
