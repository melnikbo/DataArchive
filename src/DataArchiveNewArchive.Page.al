// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved. 
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Page for creating a new data archive by recording delete operations.
/// Start logging, perform deletions elsewhere, then stop to save the archive.
/// </summary>

namespace System.DataAdministration;

page 633 "Data Archive - New Archive"
{
    Caption = 'New Data Archive';
    PageType = Card;
    UsageCategory = Administration;
    AdditionalSearchTerms = 'archive, logging, record deletions';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ArchiveName; ArchiveName)
                {
                    Caption = 'Name of new archive';
                    ToolTip = 'Specifies the name or description.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Start)
            {
                ApplicationArea = All;
                Enabled = not IsStarted;
                Caption = 'Start Logging';
                Image = Start;
                Promoted = true;
                PromotedOnly = true;
                ToolTip = 'Start logging deletions. All deletions will be added to the new archive.';
                trigger OnAction()
                begin
                    if ArchiveName = '' then
                        ArchiveName := DefaultArchiveNameLbl;
                    DataArchive.Create(ArchiveName);
                    DataArchive.StartSubscriptionToDelete(false);
                    IsStarted := true;
                    CurrPage.Update(false);
                end;
            }
            action(Stop)
            {
                ApplicationArea = All;
                Enabled = IsStarted;
                Caption = 'Stop Logging';
                Image = Stop;
                Promoted = true;
                ToolTip = 'Stop logging deletions and add the data to the new archive.';
                trigger OnAction()
                begin
                    IsStarted := false;
                    DataArchive.StopSubscriptionToDelete();
                    DataArchive.Save();
                    CurrPage.Update(false);
                end;
            }

        }
    }

    trigger OnClosePage()
    begin
        if not IsStarted then
            exit;
        IsStarted := false;
        DataArchive.StopSubscriptionToDelete();
        DataArchive.Save();
    end;

    var
        DataArchive: Codeunit "Data Archive";
        ArchiveName: Text[80];
        IsStarted: Boolean;
        DefaultArchiveNameLbl: Label 'Test', Locked = true;
        // Test change: default archive name used when user leaves field empty
}