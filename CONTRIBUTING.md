# Contributing : how to ?

If you want to help with code, first check that there is no issue already opened about the thing you want to work on. 
- If there is not, please create one. Wait for at least one other person to validate the issue you created, in order to make sure that everything is clear.
- If there is already one (that has been approved), then assign yourself on the issue and fork the repository to work on it. This is of course if no one has been assigned on this task first.

For bigger tasks that might need multiple people working on it, a branch for that specific task will be opened. Pull request will be made to this branch and not the main.

## Commits

Make commits in the following way:
- Write a clear title. If for example you decide to change a function you wrote previously, don't just write "changed function X", but explain what you changed in the function. If it's too long in a single title, it might mean you can break your commit in multiple commits. If not you can use the commit description.
- Commits should be of the minimal size possible. If you change multiple files in a single commit and the changes made don't influence each other, please break down your commit in multiple commits.

## Pull requests

Please use the pull request template located at .github/pull_request_template.md . Please link to the issue that the pull request is related to. **One Pull Request = One Issue.**

Here is a (non exhaustive) list of reasons for which your pull request can be closed :
- you didn't use the pull request template.
- you didn't open an issue related to the code you wrote or the code you wrote is not compliant with the issue.
- you didn't synchronise your fork after another pull request has been merged and that creates a lot of merge issues. Please deal with those problems locally before opening a pull request.
- you made few very big commits. Please break down your big commits in smaller and more manageable commits if possible.

## Tests

If you are writing code that implements something new, please provide test files written in GDScript (that can be run on GUT), as they will be useful to test future PR. If you do not know what to write tests on, don't hesitate to ask.

## Code formatting

As of the writing of this CONTRIBUTING.md there is no code formatter for Godot, even though it might come later. Try to follow the code conventions of the [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)

- Use static typing whenever possible (for functions parameters, variables and return types).
- Add # @Override for children classes that implement a function declared in a parent class.
- Write class name LikeThis and not like_this.
- Write function name like_this and not LikeThis.
- Write the parent class name as SomethingBase (for example, the base of the cards is `CardBase`)
- If you have C child of B and B child of A, B should not follow the previous convention, only A should. This rule may have exceptions.
- Writing multiple smaller lines is better than writing one big line.
