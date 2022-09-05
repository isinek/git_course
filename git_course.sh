#/bin/bash

LINE_WIDTH=120
TEXT_MARGINS=5
curr_dir=$( pwd )
repo_root="$curr_dir/git_pc"

TITLE_NUMBER=( 0 0 0 )

print_header()
{
	clear
	welcome_msg="GIT Course"
	l_spaces=$(( (${LINE_WIDTH} - 6 - ${#welcome_msg})/2 ))
	r_spaces=$(( ${LINE_WIDTH} - 6 - ${#welcome_msg} - ${l_spaces} ))

	printf "%0.s=" $(seq 1 ${LINE_WIDTH}); echo
	printf "==="; printf "%0.s " $(seq 1 ${l_spaces}); printf "${welcome_msg}"; printf "%0.s " $(seq 1 ${r_spaces}); printf "==="; echo
	printf "%0.s=" $(seq 1 ${LINE_WIDTH}); echo; echo
}

hr()
{
	echo; printf "%0.s-" $(seq 1 ${LINE_WIDTH}); echo; echo
}

print_section_title()
{
	title="$1"
	TITLE_NUMBER[0]=$(( ${TITLE_NUMBER[0]} + 1 ))
	TITLE_NUMBER[1]=0
	TITLE_NUMBER[2]=0

	printf "%0.s " $(seq 1 ${TEXT_MARGINS}); printf "  %d.      %s\n\n" "${TITLE_NUMBER[0]}" "${title}"
}

print_lesson_title()
{
	title="$1"
	TITLE_NUMBER[1]=$(( ${TITLE_NUMBER[1]} + 1 ))
	TITLE_NUMBER[2]=0

	printf "%0.s " $(seq 1 ${TEXT_MARGINS}); printf "  %d.%d.      %s\n\n" "${TITLE_NUMBER[0]}" "${TITLE_NUMBER[1]}" "${title}"
}

print_task_title()
{
	title="$1"
	TITLE_NUMBER[2]=$(( ${TITLE_NUMBER[2]} + 1 ))

	printf "%0.s " $(seq 1 ${TEXT_MARGINS}); printf "  %d.%d.%d.    %s\n\n" "${TITLE_NUMBER[0]}" "${TITLE_NUMBER[1]}" "${TITLE_NUMBER[2]}" "${title}"
}

print_text_block()
{
	text=( $@ )
	counter=${LINE_WIDTH}
	chars_per_line=$(( $LINE_WIDTH - $TEXT_MARGINS*2 ))
	first="1"

	for word in ${text[@]}
	do
		if [[ $(( ${counter} + ${#word} )) -gt ${chars_per_line} ]]
		then
			if [ -z "$first" ]
			then
				echo
			fi
			printf "%0.s " $(seq 1 ${TEXT_MARGINS})
			counter=0
			first=""
		fi
		printf "%s " "${word}"
		counter=$(( ${counter} + ${#word} + 1 ))
	done
	echo
}

print_line()
{
	printf "%0.s " $(seq 1 ${TEXT_MARGINS}); echo "$1"
}

print_help_text()
{
	echo
	print_text_block "Actions:"
	print_line "    h  - get hints for current task"
	print_line "    r  - reset task"
	print_line "    s  - skip current task"
	print_line "    q  - quit GIT Practice Course"
	echo
	print_line "    ?  - show this help text"
	echo
}

hint()
{
	text="$@"

	print_text_block "- hint: ${text}"
}

task_pass()
{
	msg="$1"

	printf "%0.s " $(seq 1 ${TEXT_MARGINS})
	echo "+ ${msg}"
}

task_fail()
{
	msg="$1"

	printf "%0.s " $(seq 1 ${TEXT_MARGINS})
	echo "- ${msg}"
}

press_any_key()
{
	call="$1"
	msg="-- Press any key --"
	l_spaces=$(( ${LINE_WIDTH} - ${#msg} ))

	echo
	printf "%0.s " $(seq 1 ${l_spaces}); printf "%s" "${msg}"; echo
	read -n 1 -s -r inp

	if [[ "$inp" == "h" ]] && [[ -n "$call" ]]
	then
		${call}_hint
		press_any_key $call
	elif [[ "$inp" == "s"  ]] && [[ -n "$call" ]]
	then
		${call}_solution
	elif [[ "$inp" == "r"  ]] && [[ -n "$call" ]]
	then
		${call}_clean
		press_any_key $call
	elif [[ "$inp" == "?" ]]
	then
		print_help_text
		press_any_key $call
	elif [[ "$inp" == "q" ]]
	then
		exit
	fi
}

get_commit_message()
{
	pushd ${repo_root} > /dev/null
	git log --pretty=%B -n 1 | tr '\n' ' ' | sed "s/[ ]*$//"
	popd > /dev/null
}

get_commited_files()
{
	pushd ${repo_root} > /dev/null
	git show | grep "+++ " | grep -oP "[a-zA-Z0-9]+\.[a-zA-Z0-9]+"
	popd > /dev/null
}

get_current_branch()
{
	pushd ${repo_root} > /dev/null
	git rev-parse --abbrev-ref HEAD
	popd > /dev/null
}

about_git()
{
	print_header
	print_text_block "Git is a free and open source distributed version control" \
		"system designed to handle everything from small to very large projects" \
		"with speed and efficiency."
	hr
}

before_course()
{
	print_text_block "Before we start with GIT Course, open an" \
		"additional terminal in which you will practice git commands."; echo
	print_text_block "When you are done with each task, just press any key" \
		"to check the result of your task."
	print_text_block "In case that something is not correct, you will get a" \
		"chance to repeat the task."; echo
	print_text_block "You can also use special actions at any moment."; echo
	print_help_text

	press_any_key
}

congratulations()
{
	print_header

	print_text_block "Congratulations !!!"; echo
	print_text_block "You've successfully completed GIT Basics."
	print_text_block "You are now ready to use git on your own."

	hr
}

#################
# 1. GIT Basics #
#################

GIT_BASICS=(
	git_init
	git_commit
	git_branch
	git_rebase
)

#################
# 1.1 git init  #
#################

git_init_clean()
{
	rm -rf ${repo_root} > /dev/null
}

git_init_hint()
{
	hint "mkdir ${repo_root}"
	hint "cd ${repo_root}"
	hint "git init"
}

git_init_solution()
{
	mkdir -p "${repo_root}"
	pushd "${repo_root}" > /dev/null
	git init -q > /dev/null
	popd > /dev/null
}

git_init()
{
	print_header

	print_section_title "GIT Basics"
	print_lesson_title "Init"

	while [ 1 ]
	do
		print_text_block "To work with git, we first need a git repository. Your" \
			"first task is to make a new directory ${repo_root}"; echo
		print_text_block "When you have a new directory created, initialize it as a" \
			"git repository with 'git init'."

		press_any_key git_init

		if [ ! -d "${repo_root}" ]
		then
			task_fail "New directory created"
			continue
		fi
		task_pass "New directory created"

		if [ ! -d "${repo_root}/.git" ]
		then
			task_fail "GIT repository initialize"
			continue
		fi
		task_pass "GIT repository initialized"
		break
	done
}

##################
# 1.2 git commit #
##################

git_commit_create_files()
{
	pushd ${repo_root} > /dev/null
	echo "# GIT Practice Course" > README.md
	echo "This is a test file." >> README.md

	cat > hello.c << EOF
#include <stdlib.h>
#include <stdio.h>

int main()
{
	printf("Hello World!");
	return 0;
}
EOF

	cat > hello2.c << EOF
#include <stdlib.h>
#include <stdio.h>

int main()
{
	printf("Hello again...");
	return 0;
}
EOF

	popd > /dev/null
}

git_commit_clean()
{
	pushd ${repo_root} > /dev/null
	rm -rf ./* > /dev/null
	rm -rf ./.git > /dev/null

	git_init_solution
	git_commit_create_files
}

git_commit_hint()
{
	right_comm_msg="initial commit"
	add_files="README.md"

	hint "git add ${add_files}"
	hint "git commit -m '${right_comm_msg}'"
}

git_commit_solution()
{
	git_commit_clean

	right_comm_msg="initial commit"
	add_files="README.md"

	pushd ${repo_root} > /dev/null
	git add ${add_files}
	git commit -m "${right_comm_msg}" > /dev/null
	popd > /dev/null
}

git_commit_2_prepare()
{
	wrong_comm_msg="hello world"
	add_files=( "hello.c" )

	pushd ${repo_root} > /dev/null
	git add ${add_files[@]}
	git commit --author="John Doe <>" -m "${wrong_comm_msg}" > /dev/null
	popd > /dev/null
}

git_commit_2_clean()
{
	git_commit_solution
	git_commit_2_prepare
}

git_commit_2_hint()
{
	hint "Add hello2.c to stage, amend commit and change commit message"
}

git_commit_2_solution()
{
	git_commit_2_clean

	right_comm_msg="Adding hello.c and hello2.c files"
	add_files=( "hello2.c" )

	pushd ${repo_root} > /dev/null
	git add ${add_files[@]} > /dev/null
	git commit --amend -m "${right_comm_msg}" > /dev/null
	popd > /dev/null
}

git_commit()
{
	print_lesson_title "Commits"
	print_text_block "Now when the new repository is ready, I'll prepare a few" \
		"new files. Before you start, type 'git status' to see what is new in " \
		"the repository."; echo
	print_text_block "There you should see README.md, hello.c and hello2.c files."; echo

	git_commit_create_files

	press_any_key

	# Task 1

	print_task_title "First commit"

	comm_msg="initial commit"
	files=( "README.md" )

	while [ 1 ]
	do
		print_text_block "Your first task here is to add ${files} to the stage and" \
			"then commit it with the message '${comm_msg}'."; echo
		print_text_block "NOTE: Before you commit a new file, check repository" \
			"status (git status) to be sure that you are committing the right changes."

		press_any_key git_commit

		u_comm_msg=$( get_commit_message )
		u_files=($( get_commited_files ))

		if [[ "${comm_msg}" != "${u_comm_msg}" ]]
		then
			task_fail "Wrong commit message"
			continue
		elif [[ "${files[@]}" != "${u_files[@]}" ]]
		then
			task_fail "Wrong files commited"
			continue
		fi
		task_pass "First commit created"
		break
	done
	echo

	print_text_block "After committing your changes, you can check repository " \
		"history with 'git log'."
	print_text_block "There you'll find a few important information"; echo
	print_line "commit 7e63...3456          GIT SHA is the unique ID of every commit"
	print_line "Author: $USER             Commit author"
	print_line "Date:   Thu Aug 25 ...      Date and time when the commit is created"
	print_line "    initial commit          Change description"
	echo

	press_any_key

	# Task 2

	print_task_title "Second commit"

	comm_msg="Adding hello.c and hello2.c files"
	files=( "hello.c" "hello2.c" )

	git_commit_2_prepare

	while [ 1 ]
	do
		print_text_block "Your second task will be to fix my mistake."
		print_text_block "If you want to add more changes, change commit message or" \
			"both, you can do that with 'git commit --amend'."; echo
		print_text_block "I've committed only one of two hello.c files with a " \
			"commit message that is not very descriptive."
		print_text_block "Add hello2.c file and change my commit message to '${comm_msg}'."

		press_any_key git_commit_2

		u_comm_msg=$( get_commit_message )
		u_files=($( get_commited_files ))

		if [[ "${comm_msg}" != "${u_comm_msg}" ]]
		then
			task_fail "Wrong commit message"
			continue
		elif [[ "${files[@]}" != "${u_files[@]}" ]]
		then
			task_fail "Wrong files committed"
			continue
		fi
		task_pass "Second commit created"
		break
	done
}

##################
# 1.3 git branch #
##################

git_branch_clean()
{
	git_commit_2_solution
}

git_branch_hint()
{
	right_new_branch="implement_sort"

	hint "git checkout -b ${right_new_branch}"
}

git_branch_solution()
{
	git_branch_clean

	right_new_branch="implement_sort"

	pushd ${repo_root} > /dev/null
	git checkout -q -b "${right_new_branch}"
	popd > /dev/null
}

git_branch_2_prepare()
{
    pushd ${repo_root} > /dev/null

	cat > sort.c << EOF
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
    char *list[argc - 1];
    char *tmp = NULL;
    int i, j;
	int len = argc - 1;

    for (i = 1; i < argc; ++i)
        list[i - 1] = argv[i];

    for (i = 0; i < len - 1; ++i) {
        for (j = i + 1; j < len; ++j) {
            if (strcmp(list[i], list[j]) < 0) {
                tmp = list[i];
                list[i] = list[j];
                list[j] = tmp;
            }
        }
    }

    for (i = 0; i < len; ++i)
        printf("%s ", list[i]);
    printf("\n");

    return 0;
}
EOF

    popd > /dev/null
}

git_branch_2_clean()
{
	git_branch_solution
	git_branch_2_prepare
}

git_branch_2_hint()
{
	hint "Add sort.c to stash and commit changes"
}

git_branch_2_solution()
{
	git_branch_2_clean

	right_comm_msg="Sorting application added"
	add_files=( "sort.c" )

	pushd ${repo_root} > /dev/null
	git add ${add_files[@]}
	git commit -m "${right_comm_msg}" > /dev/null
	popd > /dev/null
}

git_branch_3_clean()
{
	git_branch_2_solution
}

git_branch_3_hint()
{
	hint "Checkout master branch and use 'git merge ${right_new_branch}' to merge changes"
}

git_branch_3_solution()
{
	git_branch_3_clean

	right_new_branch="implement_sort"

	pushd ${repo_root} > /dev/null
	git checkout -q master
	git merge ${right_new_branch} > /dev/null
	popd > /dev/null
}

git_branch()
{
	print_lesson_title "Branches"
	print_text_block "Branching means you diverge from the main line of" \
		"development and continue to do work without messing with that main line."
	print_text_block "Main line is often called 'master' or 'main' branch. It" \
		"is also common to have a 'dev' branch. When all changes work on the" \
		"development branch, changes are merged to the master branch."; echo

	press_any_key

	# Task 1

	print_task_title "New branch"
	print_text_block "It is good to make a new local branch every time you are" \
		"starting with a new task. In that way, you'll be able to switch" \
		"between tasks without copy/pasting the code or saving it outside the" \
		"repository."; echo

	new_branch="implement_sort"

	while [ 1 ]
	do
		print_text_block "Your task is to create a new branch '${new_branch}' that" \
			"will diverge from current (and latest) commit on the master branch" \
			"and position yourself to a new branch."; echo
		print_text_block "You can do that in multiple ways:"
		print_line "    git branch ${new_branch}; git checkout ${new_branch}"
		print_line "                        - or -"
		print_line "    git checkout -b ${new_branch}"

		press_any_key git_branch

		pushd ${repo_root} > /dev/null
		u_branch=$( get_current_branch )
		new_branch_exists=$( git branch | grep -o "${new_branch}" )
		popd > /dev/null

		if [[ -z "${new_branch_exists}" ]]
		then
			task_fail "Create ${new_branch} branch"
			continue
		elif [[ "${new_branch}" != "${u_branch}" ]]
		then
			task_fail "Checkout ${new_branch} branch"
			continue
		fi
		task_pass "Branch ${new_branch} created"
		break
	done
	echo; echo

	# Task 2

	comm_msg="Sorting application added"
	files=( "sort.c" )

	print_task_title "Adding a feature"

	git_branch_2_prepare

	while [ 1 ]
	do
		print_text_block "Now when we have a new branch, we can write a new feature" \
		"and commit changes. I've already prepared a new file, you just need to" \
		"commit it with the message '${comm_msg}'."

		press_any_key git_branch_2

		u_branch=$( get_current_branch )
		u_comm_msg=$( get_commit_message )
		u_files=($( get_commited_files ))

		if [[ "${new_branch}" != "${u_branch}" ]]
		then
			task_fail "Checkout ${new_branch} branch"
			continue
		elif [[ "${comm_msg}" != "${u_comm_msg}" ]]
		then
			task_fail "Wrong commit message"
			continue
		elif [[ "${files[@]}" != "${u_files[@]}" ]]
		then
			task_fail "Wrong files commited"
			continue
		fi
		task_pass "Commit added to new branch"
		break
	done
	echo; echo

	# Task 3

	print_task_title "Merge"
	print_text_block "If you now check git log, you'll notice that your " \
		"implement_sort branch is one commit ahead of the master branch."; echo

	while [ 1 ]
	do
		print_text_block "We have tested our changes and we are ready to merge" \
			"changes to the master branch."
		print_text_block "To do that, you'll need to checkout master branch and" \
			"merge ${new_branch} to it."

		press_any_key git_branch_3

		u_branch=$( get_current_branch )
		u_comm_msg=$( get_commit_message )

		if [[ "master" != "${u_branch}" ]]
		then
			task_fail "Checkout master branch"
			continue
		elif [[ "${comm_msg}" != "${u_comm_msg}" ]]
		then
			task_fail "Merge ${new_branch}"
			continue
		fi
		task_pass "Sort feature is merged to master branch"
		break
	done
}


##################
# 1.4 git rebase #
##################

git_rebase_prepare()
{
	pushd ${repo_root} > /dev/null

	curr_branch=$( get_current_branch )

	git checkout -q master
	git reset -q --hard HEAD^

	cat > sum.c << EOF
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	unsigned int i, j;
	int sum = 0;

	for (i = 1; i < argc; ++i)
		sum += atoi(argv[i]);

	printf("%d\n", sum);

	return 0;
}
EOF

	git add sum.c
	git commit --author="John Doe <>" -m "Sum calculator added" > /dev/null

	git checkout -q ${curr_branch}

    popd > /dev/null
}

git_rebase_clean()
{
	git_branch_3_solution
	git_rebase_prepare
}

git_rebase_hint()
{
	right_new_branch="implement_sort"

	hint "git checkout ${right_new_branch}"
	hint "git rebase master"
	hint "git checkout master"
	hint "git merge ${right_new_branch}"
}

git_rebase_solution()
{
	git_rebase_clean

	right_new_branch="implement_sort"

	pushd ${repo_root} > /dev/null
	git checkout -q ${right_new_branch}
	git rebase -q master > /dev/null
	git checkout -q master
	git merge ${right_new_branch} > /dev/null
	popd > /dev/null
}

git_rebase_2_clean()
{
	git_rebase_solution
}

git_rebase_2_hint()
{
	hint "Create a new branch and checkout to it"
	hint "Make changes to sort.c code"
	hint "Commit your changes"
}

git_rebase_2_solution()
{
	git_rebase_2_clean

	right_new_branch="update_sort"

	pushd ${repo_root} > /dev/null
	git checkout -q -b ${right_new_branch}
	sed -i 's/< 0/> 0/' sort.c
	git add sort.c
	git commit -m "sort.c updated to sort ascending" > /dev/null
	popd > /dev/null
}

git_rebase_3_prepare()
{
	pushd ${repo_root} > /dev/null

	curr_branch=$( get_current_branch )

	git checkout -q master

	cat > sort.c << EOF
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
    char *list[argc - 1];
    char *tmp = NULL;
    int i, j;
	int len = argc - 1;

    for (i = 1; i < argc; ++i)
        list[i - 1] = argv[i];

    for (i = 0; i < len - 1; ++i) {
        for (j = i + 1; j < len; ++j) {
            if (strcmp(list[i], list[j]) < 0) {
                tmp = list[i];
                list[i] = list[j];
                list[j] = tmp;
            }
        }
    }

    for (i = len - 1; i >= 0; --i)
        printf("%s ", list[i]);
    printf("\n");

    return 0;
}
EOF

	git add sort.c
	git commit --author="John Doe <>" -m "random update" > /dev/null

	git checkout -q ${curr_branch}

    popd > /dev/null
}

git_rebase_3_clean()
{
	git_rebase_2_solution
	git_rebase_3_prepare
}

git_rebase_3_hint()
{
	hint "Rebase changes"
	hint "Change last for loop from 'for (i = len - 1; i >= 0; --i)' to 'for (i = 0; i < len; ++i)'"
	hint "Test sort app"
	hint "Merge changes to master"
}

git_rebase_3_solution()
{
	git_rebase_3_clean

	right_new_branch="update_sort"

	pushd ${repo_root} > /dev/null
	git rebase -q master
	sed -i 's/for (i = len - 1; i >= 0; --i)/for (i = 0; i < len; ++i)/' sort.c
	git add sort.c
	git commit --amend -m "sort.c updated to sort ascending" > /dev/null
	git checkout -q master
	git merge ${right_new_branch} > /dev/null
	popd > /dev/null

}

git_rebase()
{
	print_lesson_title "Rebase"

	print_text_block "In your last task you've successfully merged your changes" \
		"to the master branch, but that's not always the case, especially when" \
		"you are not working alone."; echo
	print_text_block "We'll go back in time in a parallel universe. Where" \
		"somebody else already merged his/her changes for another task."
	print_text_block "I'll fetch and pull the latest changes on the master" \
		"branch from an imaginary remote server, so you can see these in your" \
		"git tree."
	print_text_block "Before doing anything, check gitk command (if you are" \
		"using terminal, use 'git log --all --graph --decorate --oneline')."

	git_rebase_prepare

	press_any_key

	print_text_block "You can see two branches in gitk. Your feature branch" \
		"${new_branch} and master branch that has one commit more than before."; echo
	print_text_block "Now you have two options. In the first option, you'll do" \
		"exactly the same thing as before and just merge ${new_branch} to the" \
		"master branch. If you do that, git will make another merge commit and" \
		"connect everything. Do that and check gitk."

	press_any_key

	# Task 1

	git_rebase_clean

	while [ 1 ]
	do
		print_text_block "But, there's a second and better option. Before you merge" \
			"your commit, you should rebase your commit to the last commit in the" \
			"master branch. You will do that with 'git rebase master'."
		print_text_block "After rebasing check git log/gitk and merge your change" \
			"to master."

		press_any_key git_rebase

		u_branch=$( get_current_branch )
		u_comm_msg=$( get_commit_message )

		if [[ "master" != "${u_branch}" ]]
		then
			task_fail "Merge changes to the master branch"
			continue
		elif [[ "${comm_msg}" != "${u_comm_msg}" ]]
		then
			task_fail "Merge ${new_branch}"
			continue
		fi
		task_pass "Sort feature is rebased and merged to master branch"
		break
	done
	echo; echo

	# Task 2

	new_branch="update_sort"

	print_text_block "It's all fun and games when everybody works on different" \
		"files and nobody makes a mess in your little universe."
	print_text_block "Now, let's see what happens in the real world."; echo
	print_text_block "We implemented a sorting app, but somebody changed the" \
		"app description and it should sort words ascending instead of descending."

	git_rebase_2_clean

	while [ 1 ]
	do
		print_text_block "Make a new branch '${new_branch}' from the master, change" \
			"sort app to work as expected, and commit changes (do not merge it just yet)."
		print_text_block "NOTE: use 'gcc -o sort sort.c' to compile sort.c file and" \
			"test it before committing change."

		press_any_key git_rebase_2

		pushd ${repo_root} > /dev/null
		u_branch=$( get_current_branch )
		sort_result="$( gcc -o ./sort sort.c; ./sort c d a )"
		u_comm_msg=$( get_commit_message )
		u_files=$( get_commited_files )
		popd > /dev/null

		if [[ "${new_branch}" != "${u_branch}" ]]
		then
			task_fail "Checkout ${new_branch} branch"
			continue
		elif [[ "a c d " != "${sort_result}" ]]
		then
			task_fail "Fix sort.c file"
			continue
		elif [[ "sort.c" != "${u_files}" ]] || [[ "Sorting application added" == "${u_comm_msg}" ]]
		then
			task_fail "Commit just sort.c file"
			continue
		fi
		task_pass "You fixed sort.c functionality"
		break
	done
	echo; echo

	# Task 3

	print_text_block "Now, I'll again fetch and pull the latest changes for" \
		"the master branch and you check what's happening."
	print_text_block "For a start, checkout the master branch and merge your" \
		"change to it."

	git_rebase_3_prepare

	press_any_key

	print_text_block "Now try to test the sort app if it works as expected."; echo

	press_any_key

	print_text_block "It sorts in descending order again !!!"; echo
	print_text_block "In git log and gitk you can see there's another change on" \
		"the master branch, but the commit message is not very helpful. That's" \
		"the reason why it's important to have good descriptions in the commit" \
		"message."; echo
	print_text_block "To see what happened, check differences between commits."
	print_text_block "Try 'git diff [git sha]' or 'git show [git sha]' to see" \
		"what is done in last 3-4 commits."

	press_any_key

	print_text_block "Did you see what happened? That random update also fixed" \
		"the sort app to print out elements ascending, but in a different place." \
		"As a result of your merge, the sort app is broken again."; echo
	print_text_block "Let's see how to avoid situations like this one."

	press_any_key

	git_rebase_3_clean

	print_text_block "I've taken us back in time before the merge."

	while [ 1 ]
	do
		print_text_block "Now, let's try to rebase our commit, test sort app, fix" \
			"the issue by changing for loop, and merge it again."

		press_any_key git_rebase_3

		pushd ${repo_root} > /dev/null
		u_branch=$( get_current_branch )
		sort_result="$( gcc -o ./sort sort.c; ./sort c d a )"
		u_comm_msg=$( get_commit_message )
		u_files=$( get_commited_files )
		popd > /dev/null

		if [[ "master" != "${u_branch}" ]]
		then
			task_fail "Checkout master branch"
			continue
		elif [[ "a c d " != "${sort_result}" ]]
		then
			task_fail "Fix sort.c file"
			continue
		elif [[ "random update" == "${u_comm_msg}" ]]
		then
			task_fail "Merge your changes"
			continue
		fi
		task_pass "Now you fixed sort.c functionality"
		break
	done
}


########
# Main #
########

about_git
before_course

for lesson in ${GIT_BASICS[@]}
do
	${lesson}_clean
	${lesson}
	hr
done

congratulations
