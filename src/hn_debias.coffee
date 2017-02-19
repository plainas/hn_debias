
organize_into_parents_with_descendants = (comments_flat) ->
    if comments_flat.length < 2
        return comments_flat
    [head, tail...] = comments_flat
    return_array = [head]
    for tail_element in tail
        if tail_element.comment_depth > return_array[return_array.length - 1].comment_depth
            return_array[return_array.length - 1].child_comments.push tail_element
        else
            return_array.push tail_element
    return_array


recursive_build_tree = (comments) ->
    comments_two_levels = organize_into_parents_with_descendants comments
    for comment in comments_two_levels
        comment.child_comments = recursive_build_tree comment.child_comments
    comments_two_levels


#stolen from https://coffeescript-cookbook.github.io/chapters/arrays/shuffling-array-elements
shuffleArray = (source) ->
    return source unless source.length >= 2
    for index in [source.length-1..1]
        randomIndex = Math.floor Math.random() * (index + 1)
        [source[index], source[randomIndex]] = [source[randomIndex], source[index]]
    source


shuffle_tree = (source_tree) ->
    tree_with_scrambled_top_level = shuffleArray source_tree
    for subtree in tree_with_scrambled_top_level
        subtree.child_comments = shuffle_tree subtree.child_comments
    tree_with_scrambled_top_level


get_all_comments_from_dom = ->
    all_comment_nodes = document.querySelectorAll '.comtr'
    all_comments_array = []
    for comment in all_comment_nodes
        comment.comment_depth = comment.querySelector('.ind > img').getAttribute('width')
        comment.child_comments = []
        all_comments_array.push comment
    all_comments_array


append_all_comments_to_container_table = (all_comments_tree, container_table) ->
    for comment in all_comments_tree
        container_table.appendChild comment
        append_all_comments_to_container_table(comment.child_comments, container_table)


comments_table = document.querySelector '.comment-tree > tbody'
comments_table.style.visibility = 'hidden'

all_comments_array = get_all_comments_from_dom()
comments_tree = recursive_build_tree all_comments_array
shuffled_tree = shuffle_tree comments_tree
comments_table.innerHTML = ""
append_all_comments_to_container_table(shuffled_tree, comments_table)
comments_table.style.visibility = 'visible'