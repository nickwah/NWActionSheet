# NWActionSheet
A customizable action sheet for iOS. It does not do the glassy background that the default one has, but it does let you add custom views.

## Example

```objective-c
NWActionSheet *actionSheet = [[NWActionSheet alloc] init];
UIScrollView *scrollView; /* TODO: create a scrollview with images from their photos */
// If you have custom UIViews that may need to dismiss the actionsheet, they can call [actionSheet dismiss];
[actionSheet addButtonWithView:scrollView actionBlock:nil];
// If you set the actionBlock for a custom View button, it will also dismiss the actionSheet.

// Text-only buttons, like a normal actionsheet
[actionSheet addButtonWithTitle:@"Like Post" actionBlock:^{
    [self likePost];
}];
[actionSheet addButtonWithTitle:@"Delete Post" style:NWActionSheetStyleDestroy actionBlock:^{
    [self deletePost];
}];
// A nil block for a text button will automatically dismiss the sheet.
[actionSheet addButtonWithTitle:@"Cancel" style:NWActionSheetStyleCancel actionBlock:nil];
```
