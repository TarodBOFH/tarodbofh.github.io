---
template: post
title: Customizing k8s plugins autocomplete on bash and zsh
date: 2020-06-15
excerpt: >-
    In this post I'll configuring a default k8s installation to integrate with bash/zsh autocomplete, and add those
    autocomplete features on a couple of k8s plugins, for example by having kube-ctx and kube-ns plugins autocomplete
    with the contexts and namespaces currently running in our kube configurations.
toc: false
toc_sticky: true
categories:
  - Software Engineering
tags:
  - kubernetes
  - k8s
  - bash
  - zsh
header:
    teaser:        /assets/images/posts/customizing-k8s-plugins-autocomplete-on-bash-and-zsh/guillaume-bolduc-uBe2mknURG4-unsplash.jpg
    overlay_image: /assets/images/posts/customizing-k8s-plugins-autocomplete-on-bash-and-zsh/guillaume-bolduc-uBe2mknURG4-unsplash.jpg
    overlay_filter: 0.75
classes: wide
---

I was procrastinating setting up my new mac for too much time.

Today I was configuring our k8s environment, and I decided to invest some time to put the right autocomplete plugins.

I've seen some companies writing their own k8s ctl application, in order to offer a basic cmd-line interface that
either lists contexts/services or has shortcut. Sometimes the shortcuts are needed, but most of the times those could
have been solved with a plugin, like using k8s plugins and binding them into bash / zsh autocomplete.

First, we have kube config files generated per team and since as architect I work across several teams, 
I was looking to the right way to include different config files on k8s in a very standard way. 
The standard way would be a single `.kube/config` file, but I went to adding each file to my `$KUBECONFIG` env variable:

```bash
export KUBECONFIG=$KUBECONFIG:${HOME}/.cube/some-config-file:${HOME}./some-other-config-file
```

Then I setup [Krew](https://github.com/kubernetes-sigs/krew/) as per k8s recommendation:

> [Installing kubectl plugins](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/#installing-kubectl-plugins) You can use [Krew](https://github.com/kubernetes-sigs/krew/) to discover and install kubectl plugins from a community-curated [plugin index](https://github.com/kubernetes-sigs/krew-index/).

So installing krew was pretty straight forward (just have to add to `$PATH` the installation path), 
and I was ready to use the plugins I was most interested in. 
As we are having more than 200 namespaces (services) in several contexts (environments) it was a natural follow up to 
install [kubectx and kubens](https://github.com/ahmetb/kubectx).

```bash
kubectl krew install ctx
kubectl krew install ns
```

Are we done? Not yet. We lack autocomplete in the plugins. 

Both come with autocomplete on the standalone version (that is `kubectx` and `kubens`) but I prefer to stick to 
`kubectl` or as I have aliased with [bash-it](https://github.com/Bash-it/bash-it), `kc`.

There is a request on k8s to add autocomplete support to plugins [here](https://github.com/kubernetes/kubernetes/issues/74178) 
but since the support needs to be _optional_ and _universal_ there's still no agreement on how to implement it.

So let's dive a little into how to add that support ourselves.

*bash/zsh differences*: The basic procedure applies both zsh and bash but I am going to use bash as an example.

### Getting kubernetes completion on the shell

As a starting point, `kubectl` already includes [code completion](https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion) 
for bash and zsh. We will be using that as a reference for our code.

We just generate k8s completion for our shell and save in a file on our dotfiles or equivalent 
(some shells require tools like `bash-completion`; I am using `bash-it` as I said before)
```bash
kubectl completion bash > ~/.bash-it/custom/completion/custom.completion.bash
```
or if you are using `oh-my-zsh`
```bash
kubectl completion zsh > ~/.oh-my-zsh/custom.completion.kube.config
```

This is the basic step but we have not configured anything yet.

Then we need to include the generated file in our profile. 
If using bash-it it'll be included automagically with the above naming convention. 
If you're following the example on `zsh` above just add the following line to your `.zshrc` customizations:

```bash
source ~/.oh-my-zsh/custom.completion.kube.config
```

What we want at this point is:
- Add completion to kubectl to include ctx and ns commands
- After ctx complete the command with the different kube contexts
- After ns complete the command with the different kube namespaces (of the current context)

The fastest and easier way to do it is just edit our newly generated file above. With your favorite editor, 
find the function `_kubectl_root_command()` and add our new commands at the bottom of the command list:

```bash
_kubectl_root_command()
{
    last_command="kubectl"
    command_aliases=()
    
    commands=()
    commands+=("annotate")

    ...

    commands+=("wait")
    # add plugin commands to completion:
    commands+=("ctx")
    commands+=("ns")
    
    ...

}
```

If we run now kubectl with autocomplete, we get the right completions:
<figure>
    <img src="/assets/images/posts/customizing-k8s-plugins-autocomplete-on-bash-and-zsh/eg0f6ak5kyk2g9zdqpu1.png"
         alt="Image showing kubectl completion for plugins"/>
    <figcaption>Command completion is working</figcaption>
</figure>

And they also behave as we expect when we've partial words:
<figure>
    <img src="/assets/images/posts/customizing-k8s-plugins-autocomplete-on-bash-and-zsh/yzdbnpz9qxp57sinaso2.png"
         alt="Image showing partial kubectl completion for plugins"/>
    <figcaption>Command completion is working for partial words</figcaption>
</figure>

Great! We can cross the first item in our todo-list; now for the second one.

We observe that the file generated by k8s contains a bunch of _helper_ functions (those that start with `__`) and some 
_command_ functions (that start with `_`) There's also a convention on the variables they use 
(like `last_command` or the `commands` list we _hacked_ above). 
What we are going to do is to add our own _handler_ to the `kubectl` `ctx` and `ns` commands and then we will instruct the autocomplete code to do it's magic. To the magic part we will be using a function that k8s already had there but can help us to start _hacking_: `__kubectl_custom_func()`

### Define your own handler
This is straight forward. Our command is `kubectl ctx` so we define a function called `_kubectl_ctx` 
(the magic parsing on the script and autocomplete will do the rest). 
Inside our function, we clear any variable that might have been set but could _break_ some k8s commands:

I decided to add my functions at the bottom ot k8s' generated file
```bash
_kubectl_ctx()
{
    last_command="kubectl_ctx"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}
```

Those lists and flags can handle the behavior of this command but we're relying now on the custom function mentioned above.

Once we have added this, we can glue our new command to the function above.
Since we want to autocomplete with the contexts and the switch there already has a case for completing commands with 
contexts, we are almost done. We just add our new command to the right case:

```bash
__kubectl_custom_func() {
    case ${last_command} in

        ...

        kubectl_config_use-context | kubectl_config_rename-context | kubectl_ctx)
            __kubectl_config_get_contexts
            return
            ;;

        ...

        *)
            ;;
    esac
}
```

To add the namespace completion, we just add one additional case to the switch above, right before the default:

```bash
__kubectl_custom_func() {
    case ${last_command} in

        ...

        kubectl_ns)
            __kubectl_get_resource_namespace
            return
            ;;
        *)
            ;;
    esac
}
```

Don't forget to add the function to handle the ns command!:

```bash
_kubectl_ns()
{
    last_command="kubectl_ns"

    command_aliases=()

    commands=()

    flags=()
    two_word_flags=()
    local_nonpersistent_flags=()
    flags_with_completion=()
    flags_completion=()

    must_have_one_flag=()
    must_have_one_noun=()
    noun_aliases=()
}
```

This was really easy because we already had the `__kubectl_get_resource_namespace` (and get contexts) functions there,
but we could have written our own implementation.

If you want to dive deep into this subject, the generated k8s autocompletion script is full of examples.
The first iteration can be, for example, support some `kubectl` flags, like the rest of the commands;
for example, copying the available list of flags from one of them (or the root command).

Cheers!
