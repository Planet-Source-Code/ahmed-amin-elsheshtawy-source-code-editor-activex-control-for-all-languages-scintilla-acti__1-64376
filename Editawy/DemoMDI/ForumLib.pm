=Copyright Infomation
==========================================================
    Program Name    : Mewsoft Boardawy
    Program Author   : Elsheshtawy, A. A.
    Home Page          : http://www.mewsoft.com
	Email                    : support@mewsoft.com
	File Version         : 1.00
	Copyrights © 2005 Mewsoft® Corporation. All rights reserved.
==========================================================
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
==========================================================
=cut
#==========================================================
sub GetNewForumID{
my ($ID, %Forums);

	$ID = 1;
	%Forums = &GetAllForumsID;
	while ($Forums{$ID}) {$ID++;}
	return $ID;
}
#==========================================================
sub GetAllForumsID{
my ($Query, %Forums, $sth, $ID);

	$Query = qq!SELECT Forum FROM Forum_Forums!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Forums;
	while(($ID) = $sth->fetchrow_array) {$Forums{$ID}=1;}
	$sth->finish;
	return %Forums;
}
#==========================================================
sub GetForumsNumber{
my ($Query, $Count, $sth);

	$Query = qq!SELECT Count(Forum) FROM Forum_Forums!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Count = 0;
	$Count = $sth->fetchrow_array;
	$sth->finish;
	return $Count;
}
#==========================================================
sub GetForumTopics{
my ($Forum, $SortBy, $SortDir, $Period) = @_;
my ($Query, @Topics, $Dir, $TimeFilter, $Sort);
	
	if (!$Forum) {return;}
	if ($SortDir ==1 ) {$Dir = "ASC";	} else {$Dir = "DESC";}

	$TimeFilter = "";
	if ($Period > 0) {
			$TimeFilter = " AND (Time>" . (time - $Period) .")"; # $Period is in seconds
	}

	$Sort = qq!ORDER BY Type DESC!;
	if ($SortBy) {
			$Sort .= ", $SortBy $Dir";
	}

	$Query = qq!SELECT Topic FROM Forum_Topics WHERE Forum=$Forum $TimeFilter $Sort!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Topics;
	while(($ID) = $sth->fetchrow_array) {push @Topics, $ID;}
	$sth->finish;
	return @Topics;
}
#==========================================================
sub GetForumTopic{
my ($Topic) = @_;
my ($Query, $sth, $Temp, %Topic);

	if (!$Topic) {return undef;}
	$Query = qq!SELECT * FROM Forum_Topics WHERE Topic=$Topic!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Topic;
	while ($Temp = $sth->fetchrow_hashref){%Topic = %{$Temp}; last;}
	$sth->finish;
	return %Topic;
}
#==========================================================
sub GetForumLastTopic{
my ($Forum) = @_;
my ($Query, $sth, $ID, $Found);
	
	$Query = qq!SELECT Topic FROM Forum_Topics WHERE Forum=$Forum ORDER BY TIME DESC!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Found = "";
	while(($ID) = $sth->fetchrow_array) {$Found = $ID;}
	$sth->finish;
	return $Found;
}
#==========================================================
sub GetForumLastPost{
my ($Forum) = @_;
my ($Query, $sth, $ID, $Found);
	
	$Query = qq!SELECT Post FROM Forum_Posts WHERE Forum=$Forum ORDER BY TIME DESC!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Found = "";
	while(($ID) = $sth->fetchrow_array) {$Found = $ID;}
	$sth->finish;
	return $Found;
}
#==========================================================
sub GetNewTopicID{
my ($ID, %Topics);

	$ID = 1;
	%Topics = &GetAllTopicsID;
	while ($Topics{$ID}) {$ID++;}
	return $ID;
}
#==========================================================
sub GetAllTopicsID{
my ($Query, %Topics, $sth, $ID);

	$Query = qq!SELECT Topic FROM Forum_Topics!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Topics;
	while(($ID) = $sth->fetchrow_array) {$Topics{$ID}=1;}
	$sth->finish;
	return %Topics;
}
#==========================================================
sub GetNewPostID{
my ($ID, %Posts);

	$ID = 1;
	%Posts = &GetAllPostsID;
	while ($Posts{$ID}) {$ID++;}
	return $ID;
}
#==========================================================
sub GetAllPostsID{
my ($Query, %Posts, $sth, $ID);

	$Query = qq!SELECT Post FROM Forum_Posts!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Posts;
	while(($ID) = $sth->fetchrow_array) {$Posts{$ID}=1;}
	$sth->finish;
	return %Posts;
}
#==========================================================
sub GetForumPost{
my ($Post) = @_;
my ($Query, %Post);

	$Query = qq!SELECT * FROM Forum_Posts WHERE Post=$Post!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Post;
	while ($Temp = $sth->fetchrow_hashref){%Post = %{$Temp}; last;}
	$sth->finish;
	return %Post;
}
#==========================================================
sub GetForumPostMedia{
my ($Post) = @_;
my ($Query, %Post);

	$Query = qq!SELECT * FROM Forum_Media WHERE Post=$Post!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Post;
	while ($Temp = $sth->fetchrow_hashref){%Post = %{$Temp}; last;}
	$sth->finish;
	return %Post;
}
#==========================================================
sub GetForumTopicsCount{
my ($Forum) = @_;
my ($Query, $Count, $sth);

	$Query = qq!SELECT Count(Topic) FROM Forum_Topics WHERE Forum=$Forum!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Count = 0;
	$Count = $sth->fetchrow_array;
	$sth->finish;
	return $Count;
}
#==========================================================
sub GetForumPostsCount{
my ($Forum) = @_;
my ($Query, $Count, $sth);

	$Query = qq!SELECT Count(Post) FROM Forum_Posts WHERE Forum=$Forum!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Count = 0;
	$Count = $sth->fetchrow_array;
	$sth->finish;
	return $Count;
}
#==========================================================
sub GetForumsTopicsCount{
my ($Query, $Count, $sth);

	$Query = qq!SELECT Count(Topic) FROM Forum_Topics!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Count = 0;
	$Count = $sth->fetchrow_array;
	$sth->finish;
	return $Count;
}
#==========================================================
sub GetForumsPostsCount{
my ($Query, $Count, $sth);

	$Query = qq!SELECT Count(Post) FROM Forum_Posts!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Count = 0;
	$Count = $sth->fetchrow_array;
	$sth->finish;
	return $Count;
}
#==========================================================
sub GetForumTopicPosts{
my ($Topic) = @_;
my ($Query, @Posts);

	undef @Posts;
	if (!$Topic) {return @Posts;}
	$Query = qq!SELECT Post FROM Forum_Posts WHERE Topic=$Topic ORDER BY Time ASC!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	while(($ID) = $sth->fetchrow_array) {push @Posts, $ID;}
	$sth->finish;
	return @Posts;
}
#==========================================================
sub GetForumMessage{
my ($Post) = @_;
my ($Query, %Message);

	$Query = qq!SELECT * FROM Forum_Messages WHERE Post=$Post!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Message;
	while ($Temp = $sth->fetchrow_hashref){%Message = %{$Temp}; last;}
	$sth->finish;
	return %Message;
}
#==========================================================
sub DeleteForumPost{
my ($Post) = @_;
my ($Query, $sth, @Media, $Temp, $Media, @Files, $File);

	# Delete post attached files 
	$Query = qq!SELECT Media FROM Forum_Media WHERE Post=$Post!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Media;
	while (($Temp) = $sth->fetchrow_array){push @Media, $Temp;}
	$sth->finish;

	foreach $Media (@Media) {
			@Files = split(/\|/, $Media);
			foreach $File (@Files){
					unlink ("$Global{Upload_Dir}/$File");
			}
	}

	$Query = qq!DELETE FROM Forum_Posts WHERE Post=$Post!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);

	$Query = qq!DELETE FROM Forum_Messages WHERE Post=$Post!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);

	$Query = qq!DELETE FROM Forum_Media WHERE Post=$Post!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
}
#==========================================================
sub GetForumIPUsers{
my ($IP, $SortDir) = @_;
my ($Query, $sth, $User, $Posts, @Users, $Counter);

	$IP = $dbh->quote($IP);
	$Query = qq!SELECT Author, COUNT(*) FROM Forum_Posts WHERE IP=$IP GROUP BY Author!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Users;
	$Counter = 0;
	while(($User, $Posts) = $sth->fetchrow_array) {
			@{$Users[$Counter++]}{qw(User Posts)} = ($User, $Posts);
	}
	$sth->finish;

	$SortDir ||= 0;
	if ($SortDir) {
				@Users = sort { $a->{Posts} <=> $b->{Posts} } @Users;
	}
	else{
				@Users = sort { $b->{Posts} <=> $a->{Posts} } @Users;
	}
	return @Users;
}
#==========================================================
sub GetForumUserIPs{
my ($Author, $SortDir) = @_;
my ($Query, $sth, $IP, $Posts, @IP, $Counter);

	$Author = $dbh->quote($Author);
	$Query = qq!SELECT IP, COUNT(*) FROM Forum_Posts WHERE Author=$Author GROUP BY IP!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @IP;
	$Counter = 0;
	while(($IP, $Posts) = $sth->fetchrow_array) {
			@{$IP[$Counter++]}{qw(IP Posts)} = ("$IP", $Posts);
	}
	$sth->finish;

	$SortDir ||= 0;
	if ($SortDir) {
				@IP = sort { $a->{Posts} <=> $b->{Posts} } @IP;
	}
	else{
				@IP = sort { $b->{Posts} <=> $a->{Posts} } @IP;
	}
	return @IP;
}
#==========================================================
sub GetTopicLastPost{
my ($Topic) = @_;
my ($Query, %Post);

	$Query = qq!SELECT * FROM Forum_Posts WHERE Topic=$Topic ORDER BY Time DESC!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Post;
	while ($Temp = $sth->fetchrow_hashref){%Post = %{$Temp}; last;}
	$sth->finish;
	return %Post;
}
#==========================================================
sub GetForumName{
my ($Forum) = @_;
my ($Query, $sth, $Name);
	
	if ($Forum < 1) {return undef;}
	$Query = qq!SELECT Name FROM Forum_Forums WHERE Forum=$Forum!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	while(($Name) = $sth->fetchrow_array) {last;}
	$sth->finish;
	return $Name;
}
#==========================================================
sub GetNewForumCashID{
my ($ID, $Query, $sth);

	$ID = time;
	$Query = qq!SELECT Cash FROM Forum_Search WHERE Cash=?!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	while (1) {
			$sth->execute($ID) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
		    if (($Row) = $sth->fetchrow_array) {$ID++; }
			else{last;}
	}
	return $ID;
}
#==========================================================
sub GetForumCash{
my ($CashID) = @_;
my ($Query, $sth, $Temp, %Result);

	if ($CashID !~ m/\d+/) {return undef;}
	$Query = qq!SELECT * FROM Forum_Search WHERE Cash=$CashID!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Result;
	while ($Temp = $sth->fetchrow_hashref){%Result = %{$Temp}; last;}
	$sth->finish;
	return %Result;
}
#==========================================================
sub PagesNumbers{
my ($Current_Page, $Last_Page) = @_;
my ($TotalPages, %Pages, $Count, $Div, $Page);
my ($LtPage, $RtPage, @Pages);

	if ($Last_Page <= 25) {$Div = 1;}
	elsif ($Last_Page > 25 && $Last_Page <= 50) {$Div = 2;}
	elsif ($Last_Page > 50 && $Last_Page <= 75) {$Div = 3;}
	elsif ($Last_Page > 75 && $Last_Page <= 100) {$Div = 4;}
	elsif ($Last_Page > 100 && $Last_Page <= 250) {$Div = 5;}
	elsif ($Last_Page > 250 && $Last_Page <= 500) {$Div = 10;}
	elsif ($Last_Page > 500 && $Last_Page <= 1000) {$Div = 20;}
	elsif ($Last_Page > 1000 && $Last_Page <= 2500) {$Div = 40;}
	elsif ($Last_Page > 2500 && $Last_Page <= 5000) {$Div = 100;}
	elsif ($Last_Page > 5000 && $Last_Page <= 7500) {$Div = 150;}
	elsif ($Last_Page > 7500 && $Last_Page <= 10000) {$Div = 200;}
	elsif ($Last_Page > 10000) {$Div = 250;}
	
	$TotalPages = int($Last_Page / $Div);

	undef %Pages;
	for $Count(1..$TotalPages) {
		$Page = $Count * $Div;
		$Pages{$Page} = 1;
	}

	$LtPage = $Current_Page-5;
	$RtPage = $Current_Page+5;
	
	if ($LtPage < 1 ) {$LtPage = 1;}

	if ($RtPage > $Last_Page) {$RtPage = $Last_Page;}

	for $Page($LtPage..$RtPage) {
			$Pages{$Page} = 1;
	}
	
	@Pages = sort {$a <=> $b} keys %Pages;
	return @Pages;
}
#==========================================================
sub Search_Forums{
my ($Terms, $Forums, $SearchMsg, $Period, $Authors, $Mode, $SortBy, $SortDir, $SaveCash) = @_;
my (@Terms, $Term, %Required, %Execlud, %Optional);
my ($Query, $What, $AND, $OR, $NOT, $sth, $Data, @Items, $x);
my ($TimeFilter, @AuthorsFilter, $Author, $AuthorsFilter, $Dir);
my ($Temp, $Cash, $Time, $Result);

	@Terms = &PrepareForumSearchTerms($Terms);

	if (!@Terms) {
				$Global{Total_Matched_Count} = 0;
				undef @Items;
				return ("", @Items);
	}
	#------------------------------------------------------
	if ($SortDir ==1 ) {$Dir = "ASC";	} else {$Dir = "DESC";}
	#------------------------------------------------------
	foreach $Term(@Terms) {
				if ($Term =~ /^\+/) {$Term =~s/\+//; $Required{$Term}=1;}      
				elsif ($Term =~ /^\-/) {$Term =~s/\-//; $Execlud{$Term}=1;}      
				elsif ($Term =~ /^\|/) {$Term =~s/\|//; $Optional{$Term}=1;}      
				else {$Required{$Term}=1;}
	}
	
	if ($Global{Maximum_Search_Results}) {
			if ($Global{DB_Server} eq "MS_SQL") {
					$Query = qq!SELECT TOP $Global{Maximum_Search_Results} Post FROM Forum_Messages WHERE  !;
			}
			else{
					$Query = qq!SELECT Post FROM Forum_Messages WHERE !;
			}
	}
	else{
			$Query = qq!SELECT Post FROM Forum_Messages WHERE !;
	}
	

	if ($Forums) {
			$Query .= qq! Forum IN ($Forums) AND !;
	}

	$Query .= "(";

	$What = "Subject"; # Subject, Message

	$AND = "";
	foreach $Term (keys %Required) {$AND .= "$What LIKE \'%$Term%' AND ";}
	$AND =~ s/AND\s*$//;

	$OR = "";
	foreach $Term (keys %Optional) {$OR .= "$What LIKE \'%$Term%\' OR ";}
	$OR =~ s/OR\s*$//;

	$NOT = "";
	foreach $Term(keys %Execlud) {$NOT .= "$What NOT LIKE \'%$Term%\' AND ";}
	$NOT =~ s/AND\s*$//;

	if ($AND) {$Query .= " ($AND) ";}
	
	if ($NOT and $AND) {
			$Query .= " AND ($NOT) ";
	}
	elsif ($NOT) {
			$Query .= " ($NOT) ";
	}

	if ($OR && ($AND || $NOT)) {
			$Query .= " OR ($OR) ";
	}
	elsif ($OR) {
			$Query .= " ($OR) ";
	}

	$Query =~ s/AND\s*$//;
	
	if ($SearchMsg) {
				$Query .= " OR ";
				$What = "Message"; # Subject, Message

				$AND = "";
				foreach $Term (keys %Required) {$AND .= "$What LIKE \'%$Term%' AND ";}
				$AND =~ s/AND\s*$//;

				$OR = "";
				foreach $Term (keys %Optional) {$OR .= "$What LIKE \'%$Term%\' OR ";}
				$OR =~ s/OR\s*$//;

				$NOT = "";
				foreach $Term(keys %Execlud) {$NOT .= "$What NOT LIKE \'%$Term%\' AND ";}
				$NOT =~ s/AND\s*$//;

				$Query =~ s/AND\s*$//;
				
				if ($AND) {$Query .= " ($AND) ";}
				
				if ($NOT and $AND) {
						$Query .= " AND ($NOT) ";
				}
				elsif ($NOT) {
						$Query .= " ($NOT) ";
				}

				if ($OR && ($AND || $NOT)) {
						$Query .= " OR ($OR) ";
				}
				elsif ($OR) {
						$Query .= " ($OR) ";
				}

				$Query =~ s/AND\s*$//;
	}
	$Query .= ")";

	if ($Global{DB_Server} eq "MS_SQL") {}
	else{
			if ($Global{Maximum_Search_Results}) {$Query .= " LIMIT $Global{Maximum_Search_Results} ";}
	}

	if ($Mode != 1 && $SortBy eq "Title") {# sort posts by subject
			$Query .= qq! ORDER BY Subject $Dir!;
	}

	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth ->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Data = $sth->fetchall_arrayref;
	$sth->finish;
	undef @Items;
	for $x (0..@{$Data}-1) {push @Items, $Data->[$x][0];}
	$Global{Total_Matched_Count} = @Items;
	# @Items now contains the search results as posts not sorted or filtered
	#------------------------------------------------------
	if (!@Items) {undef @Items; return ("", @Items);}
	#------------------------------------------------------
	# Filter results by time and authors if any required
	$TimeFilter = "";
	if ($Period > 0) {
			$TimeFilter = int(time - $Period * 86400);
			$TimeFilter = "AND (Time > $TimeFilter)";
	}
	# Filter by authors
	$Authors =~ s/\,+/ /g;
	@AuthorsFilter = split (/\s+/, $Authors);

	$AuthorsFilter = "";
	if (@AuthorsFilter) {
			foreach $Author (@AuthorsFilter) {
					$Author =~ s/\*+/\%/g;
					$AuthorsFilter .= "Author Like  \'$Author\' OR ";
			}
			$AuthorsFilter =~ s/OR\s+$//g;
			$AuthorsFilter = "AND ($AuthorsFilter)";
	}
	#------------------------------------------------------
	#------------------------------------------------------
	# return result as sorted posts or topics and apply filters if required
	$Posts = join (",", @Items);

	# filter search results by time and authors
	$Query = qq!SELECT Post, Topic FROM Forum_Posts WHERE Post IN ($Posts) $TimeFilter $AuthorsFilter!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Items; undef %Topics;
	while(($Post, $Topic) = $sth->fetchrow_array) {
			push @Items, $Post;
			$Topics{$Topic} = 1;
	}
	$sth->finish;
	$Global{Total_Matched_Count} = @Items;
	#------------------------------------------------------
	if (!@Items) {undef @Items; return ("", @Items);}
	#------------------------------------------------------
	$Sort = qq!ORDER BY Type DESC!;
	if ($SortBy) {
			$Sort .= ", $SortBy $Dir";
	}

	if ($Mode == 1) { # return the result as topics sort
			$Topics =  join (",", keys %Topics);
			$Query = qq!SELECT Topic FROM Forum_Topics WHERE Topic IN ($Topics) GROUP BY Topic $Sort!;
			$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			undef @Items;
			while(($Temp) = $sth->fetchrow_array) {push @Items, $Temp;}
			$sth->finish;
			$Global{Total_Matched_Count} = @Items;
	}
	else{ # return the result as posts sorted
			$Posts =  join (",", @Items);
			if ($SortBy eq "Time" || $SortBy eq "Updated" || $SortBy eq "Author") {
					$Query = qq!SELECT Post FROM Forum_Posts WHERE Post IN ($Posts) ORDER BY $SortBy $Dir!;
					$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
					$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
					undef @Items;
					while(($Temp) = $sth->fetchrow_array) {push @Items, $Temp;}
					$sth->finish;
					$Global{Total_Matched_Count} = @Items;
			}
	}
	#------------------------------------------------------
	#------------------------------------------------------
	# save the search result in the cash if required
	$Cash = "";
	if ($SaveCash) {
				# Delete any old search cash
				$Time = time - int($Global{Forum_Cash_Time}*60);
				$Query = qq!DELETE FROM Forum_Search WHERE Time<=$Time!;
				$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
				#------------------------------------------------------
				# Create new search cash for this search term
				$Result = join (",", @Items);
				$Result = $dbh->quote($Result);
				
				$Cash = &GetNewForumCashID;
				$Time = time;
				$Forums1 = $dbh->quote($Forums);
				$Term = $dbh->quote($Terms);
				$AuthorsFilter = $dbh->quote($Authors);

				$Query = qq!INSERT INTO Forum_Search SET 
											Cash=$Cash,
											Time=$Time,
											Forums=$Forums1,
											Terms=$Term,
											Authors='',
											AuthorsFilter=$AuthorsFilter,
											Mode=$Mode,
											Period=$Period,
											TitlesOnly=$SearchMsg,
											Result=$Result
									!;
				$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	}
	#------------------------------------------------------
	#&p ($Query);
	return ($Cash, @Items);
}
#==========================================================
sub Search_Forums_Authors{
my ($Authors, $Forums, $Period, $Mode, $SortBy, $SortDir, $SaveCash) = @_;
my (@Items, $TimeFilter, @AuthorsFilter, $AuthorsFilter, $Author, $Temp);
my ($ForumsFilter, $Query, $sth, $Post, $Topic, $Topics, $Posts, %Topics);
my ($Cash, $Dir, $Time, $Result, $Forums1, $Term);

	if (!$Authors) {
			undef @Items; return ("", @Items);
	}
	#------------------------------------------------------
	# Filter results by time and authors
	$TimeFilter = "";
	if ($Period > 0) {
			$TimeFilter = int(time - $Period * 86400);
			 $TimeFilter = qq! AND(Time>$TimeFilter)!;
	}
	# Filter by authors
	$Authors =~ s/\,+/ /g;
	@AuthorsFilter = split (/\s+/, $Authors);

	$AuthorsFilter = "";
	if (@AuthorsFilter) {
			foreach $Author (@AuthorsFilter) {
					$Author =~ s/\*+/\%/g;
					$AuthorsFilter .= "Author Like  \'$Author\' OR ";
			}
			$AuthorsFilter =~ s/OR\s+$//g;
			$AuthorsFilter = "($AuthorsFilter)";
	}
	#------------------------------------------------------
	$ForumsFilter = "";
	if ($Forums) {
			$ForumsFilter = qq! AND Forum IN ($Forums)!;
	}
	#------------------------------------------------------
	if ($SortDir ==1 ) {$Dir = "ASC";	} else {$Dir = "DESC";}
	#------------------------------------------------------
	$Query = qq!SELECT Post, Topic FROM Forum_Posts WHERE $AuthorsFilter $TimeFilter $ForumsFilter!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Items; undef %Topics;
	while(($Post, $Topic) = $sth->fetchrow_array) {
			push @Items, $Post;
			$Topics{$Topic} = 1;
	}
	$sth->finish;
	$Global{Total_Matched_Count} = @Items;
	#------------------------------------------------------
	if (!@Items) {undef @Items; return ("", @Items);}
	#------------------------------------------------------
	$Sort = qq!ORDER BY Type DESC!;
	if ($SortBy) {
			$Sort .= ", $SortBy $Dir";
	}

	if ($Mode == 1) { # return the result as topics sorted
			$Topics =  join (",", keys %Topics);
			$Query = qq!SELECT Topic FROM Forum_Topics WHERE Topic IN ($Topics) GROUP BY Topic $Sort!;
			$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			undef @Items;
			while(($Temp) = $sth->fetchrow_array) {push @Items, $Temp;}
			$sth->finish;
			$Global{Total_Matched_Count} = @Items;
	}
	else{ # return the result as posts sorted
			$Posts =  join (",", @Items);
			if ($SortBy eq "Time" || $SortBy eq "Updated" || $SortBy eq "Author") {
					$Query = qq!SELECT Post FROM Forum_Posts WHERE Post IN ($Posts) ORDER BY $SortBy $Dir!;
					$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
					$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
					undef @Items;
					while(($Temp) = $sth->fetchrow_array) {push @Items, $Temp;}
					$sth->finish;
					$Global{Total_Matched_Count} = @Items;
			}
	}
	#------------------------------------------------------
	if (!@Items) {return ("", @Items);}
	#------------------------------------------------------
	#------------------------------------------------------
	# save the search result in the cash if required
	$Cash = "";
	if ($SaveCash) {
				# Delete any old search cash
				$Time = time - int($Global{Forum_Cash_Time}*60);
				$Query = qq!DELETE FROM Forum_Search WHERE Time<=$Time!;
				$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
				#------------------------------------------------------
				# Create new search cash for this search term
				$Result = join (",", @Items);
				$Result = $dbh->quote($Result);
				
				$Cash = &GetNewForumCashID;
				$Time = time;
				$Forums1 = $dbh->quote($Forums);
				$Term = $dbh->quote($Terms);
				$AuthorsFilter = $dbh->quote($Authors);

				$Query = qq!INSERT INTO Forum_Search SET 
											Cash=$Cash,
											Time=$Time,
											Forums=$Forums1,
											Terms='',
											Authors=$AuthorsFilter,
											AuthorsFilter='',
											Mode=$Mode,
											Period=$Period,
											TitlesOnly=1,
											Result=$Result
									!;
				$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	}
	#------------------------------------------------------
	return ($Cash, @Items);
}
#==========================================================
sub ParseForumTopicsList{
my ($Action, $Template, $Form1, $Form2, $Mode, $User, $PostLink, @Topics) = @_;
my (@Forms, $Total_Count, $Last_Page, $Current_Page);
my ($Next_Page, $Previous_Page, $Temp, $Pages, @Pages, $Link);
my ($Start, $End, $LastPostTimeClass, $LastPostTimeFormat, $Output);
my ($Counter, $Topic, %Topic, $Form, %Forum, %LastPost);

	$Template =~ s/<!--Action-->/$Script_URL/g;
	$Template =~ s/<!--Language-->/$Global{Language}/g;
	$Template =~ s/<!--Forum-->/$Param{Forum}/g;
	$Template =~ s/<!--Category-->/$Param{Category}/g;
	#------------------------------------------------------
	@Forms = (&Translate($Form1), &Translate($Form2));
	#------------------------------------------------------
	$Param{Page} ||= 1;
	$Total_Count = @Topics;
	
	$Global{Topics_Per_Page} ||= 10;
	$Param{PageSize} ||= $Global{Topics_Per_Page};

	$Last_Page = int ($Total_Count / $Param{PageSize});
	if (($Total_Count % $Param{PageSize})) {$Last_Page++;}
	$Current_Page = $Param{Page};
	$Next_Page = $Current_Page + 1;
	$Previous_Page = $Current_Page - 1;
	if ($Next_Page > $Last_Page) {$Next_Page = $Last_Page;}
	#----------------------------------------------
	$Next_Page_URL = qq!$Script_URL?$Action&Sorted=0&Sort=$Param{Sort}&Dir=$Param{Dir}&Page=$Next_Page&PageSize=$Param{PageSize}&Period=$Param{Period}&Lang=$Global{Language}!;
	$Previous_Page_URL = qq!$Script_URL?$Action&Sorted=0&Sort=$Param{Sort}&Dir=$Param{Dir}&Page=$Previous_Page&PageSize=$Param{PageSize}&Period=$Param{Period}&Lang=$Global{Language}!;
	#----------------------------------------------
	if ($Current_Page == $Last_Page || $Total_Count <= 0) {
			$Temp = $Language{topics_last_page};
	}
	else{
			$Temp = $Language{topics_next_page};
			$Temp =~ s/<!--Next_Page_URL-->/$Next_Page_URL/g;
	}
	$Template =~ s/<!--Next_Page-->/$Temp/g;

	if ($Current_Page == 1) {
			$Temp = $Language{topics_first_page};
	}
	else{
			$Temp = $Language{topics_previous_page};
			$Temp =~ s/<!--Previous_Page_URL-->/$Previous_Page_URL/g;
	}
	$Template =~ s/<!--Previous_Page-->/$Temp/g;
	#----------------------------------------------
	$Pages = ""; 
	@Pages = &PagesNumbers($Current_Page, $Last_Page);

	foreach $Page(@Pages) {
			if ($Page == $Current_Page) {
					$Link = $Language{topics_current_page_link};
			}
			else{
					$Link = $Language{topics_pages_link};
			}
			$Temp = qq!$Script_URL?$Action&Sorted=0&Sort=$Param{Sort}&Dir=$Param{Dir}&Page=$Page&PageSize=$Param{PageSize}&Period=$Param{Period}&Lang=$Global{Language}!;
			$Link =~ s/<!--Link-->/$Temp/;
			$Link =~ s/<!--Page-->/$Page/;
			$Pages .= $Link;
			if ($Page != $Last_Page) {
					$Pages .= $Language{topics_pages_link_separtor};
			}
	}
	$Pages =~ s/$Language{topics_pages_link_separtor}$//g;
	$Template =~ s/<!--Pages-->/$Pages/g;
	#----------------------------------------------
	$Temp = $Language{topics_showing_page};
	$Temp =~ s/<!--CurrentPage-->/$Current_Page/g;
	$Temp =~ s/<!--TotalPages-->/$Last_Page/g;
	$Template =~ s/<!--Showing_Page-->/$Temp/g;
	#------------------------------------------------------
	$Start = ($Current_Page - 1) * $Param{PageSize};
	$End = $Start + $Param{PageSize};
	if ($End > $Total_Count) {$End = $Total_Count;}
	#------------------------------------------------------
	$Plugins{ResultsFound} =~ s/<!--Found-->/$Total_Count/g;
	$Temp = $Start+1;
	$Plugins{ResultsFound} =~ s/<!--FoundStart-->/$Temp/g;
	$Plugins{ResultsFound} =~ s/<!--FoundEnd-->/$End/g;
	#------------------------------------------------------

	$LastPostTimeClass = ""; $LastPostTimeFormat = "";	# <!--LastPostTime:(WD-MD-YY-HH-MM-AP)-->
	if ($Forms[0] =~ m/(<!--)(LastPostTime)(:\()([^\)]+)(\)-->)/){
				$LastPostTimeClass = $1 . $2 . $3. $4. $5;
				$LastPostTimeFormat =  $4;
	}
	$LastPostTimeClass =~ s/\(/\\\(/g;
	$LastPostTimeClass =~ s/\)/\\\)/g;
	#------------------------------------------------------
	# Get the topics read by the current user for the current page only
	$User ||= "";
	%Read = &GetForumUserTopicsRead($User, @Topics[$Start..$End-1]);
	#------------------------------------------------------
	$Output = "";
	for $Counter ($Start..$End-1){
				$Topic = $Topics[$Counter];
				%Topic = &GetForumTopic($Topic);

				$Form = $Forms[int($Counter % 2)]; 
				#----------------------------------------------------------------------------------
				# topic icon according to Type, Status, Read
				if (!$Read{$Topic}) {# new topic
						if (!$Topic{Status}) { # open topic
								$Icon = $Language{topic_icon_new};
						}
						else{ # locked topic
								$Icon = $Language{topic_icon_new_locked};
						}
				}
				else{ #old topic
						if (!$Topic{Status}) { # open topic
								$Icon = $Language{topic_icon_old};
						}
						else{ # locked topic
								$Icon = $Language{topic_icon_old_locked};
						}
				}

				$Form =~ s/<!--Status-->/$Icon/g;
				#----------------------------------------------------------------------------------
				if ($Topic{Replies} >= $Global{HotTopicsPosts}){
						$Icon = $Language{topic_icon_hot};
				}
				elsif ($Topic{Replies} >= $Global{PopularTopicsPosts}){
						$Icon = $Language{topic_icon_popular};
				}
				elsif ($Topic{Replies} >= $Global{CoolTopicsPosts}){
						$Icon = $Language{topic_icon_cool};
				}
				else{
						$Icon = $Language{topic_icon_normal};
				}				
				$Form =~ s/<!--Rank-->/$Icon/g;
				#----------------------------------------------------------------------------------
				$Temp = $Counter + 1;
				$Form =~ s/<!--Counter-->/$Temp/g;

				$Temp = $Topic{Type}; # Normal, Sticky, Announcement
				if ($Topic{Type} == 1) {
						$Temp = $Language{sticky_topic};
				}
				elsif ($Topic{Type} == 2) {
						$Temp = $Language{announcement_topic};
				}
				else{
						$Temp = "";
				}
				$Form =~ s/<!--Type-->/$Temp/g;

				$Temp = "";
				if ($Topic{Poll}) {$Temp = $Language{topic_has_poll};}
				$Form =~ s/<!--Poll-->/$Temp/g;
				#--------------------------------------------------------------
				#Forum_Media
				#--------------------------------------------------------------
				$Temp = qq!$Script_URL?action=ViewTopic&Topic=$Topic&Forum=$Topic{Forum}&Page=1&Period=$Param{Period}&Lang=$Global{Language}!;
				$Form =~ s/<!--TitleLink-->/$Temp/g;

				$Temp = $Topic{Title};
				$Form =~ s/<!--Title-->/$Temp/g;

				$Temp = $Topic{Title};
				$Form =~ s/<!--Preview-->/$Temp/g;

				if ($Topic{Replies} > 0) {$Temp = $Topic{Replies};}else {$Temp = $Language{zero_replies};}
				$Form =~ s/<!--Replies-->/$Temp/g;
				
				$Temp = qq!$Script_URL?action=ViewProfile&Author=$Topic{Author}&Lang=$Global{Language}!;
				$Form =~ s/<!--AuthorLink-->/$Temp/g;
				
				$Temp = $Topic{Author};
				$Form =~ s/<!--Author-->/$Temp/g;

				if ($Topic{Views} > 0) {$Temp = $Topic{Views};}else {$Temp = $Language{zero_views};}
				$Form =~ s/<!--Views-->/$Temp/g;
				
				$Temp = $Topic{LastPost};
				$Form =~ s/<!--LastPost-->/$Temp/g;

				$Temp = qq!$Script_URL?action=ViewProfile&Author=$Topic{Author}&Lang=$Global{Language}!;
				$Form =~ s/<!--LastPostAuthorLink-->/$Temp/g;
				
				if ($Mode == 1) { # show forum name for topics
						%Forum = &GetForum($Topic{Forum});
						$Temp = qq!$Script_URL?action=Forums&Forum=$Topic{Forum}&Period=$Param{Period}&Lang=$Global{Language}!;
						$Form =~ s/<!--ForumLink-->/$Temp/g;
						$Form =~ s/<!--ForumName-->/$Forum{Name}/g;
				}
				
				%LastPost = &GetForumPost($Topic{LastPost});
				$Form =~ s/<!--LastPostAuthor-->/$LastPost{Author}/g;
				#Time parser: date= YY, MONTH, MON, MD, WD, time= HR, HH:MM:SS
				if ($LastPost{Time} > 0) {
						$Temp = &ParseDate($LastPostTimeFormat, $LastPost{Time});
				}
				else{	
						$Temp = "";
				}
				$Form =~ s/$LastPostTimeClass/$Temp/g;

				$Counter++;
				$Form =~ s/<!--Counter-->/$Counter/g;

				$Output .= $Form;
	}

	$Template =~ s/<!--TopicsList-->/$Output/;
	#------------------------------------------------------
	$Plugins{SortTitle} = qq!$Script_URL?$Action&Sorted=1&Sort=Title&Dir=$Param{Dir}&Page=1&PageSize=$Param{PageSize}&Period=$Param{Period}&Lang=$Global{Language}!;
	$Plugins{SortReplies} = qq!$Script_URL?$Action&Sorted=1&Sort=Replies&Dir=$Param{Dir}&Page=1&PageSize=$Param{PageSize}&Period=$Param{Period}&Lang=$Global{Language}!;
	$Plugins{SortAuthor} = qq!$Script_URL?$Action&Sorted=1&Sort=Author&Dir=$Param{Dir}&Page=1&PageSize=$Param{PageSize}&Period=$Param{Period}&Lang=$Global{Language}!;
	$Plugins{SortViews} = qq!$Script_URL?$Action&Sorted=1&Sort=Views&Dir=$Param{Dir}&Page=1&PageSize=$Param{PageSize}&Period=$Param{Period}&Lang=$Global{Language}!;
	$Plugins{SortTime} = qq!$Script_URL?$Action&Sorted=1&Sort=Time&Dir=$Param{Dir}&Page=1&PageSize=$Param{PageSize}&Period=$Param{Period}&Lang=$Global{Language}!;
	$Plugins{SortUpdated} = qq!$Script_URL?$Action&Sorted=1&Sort=Updated&Dir=$Param{Dir}&Page=1&PageSize=$Param{PageSize}&Period=$Param{Period}&Lang=$Global{Language}!;

	$Plugins{SortTitleImg} = "";
	$Plugins{SortRepliesImg} = "";
	$Plugins{SortAuthorImg} = "";
	$Plugins{SortViewsImg} = "";
	$Plugins{SortTimeImg} = "";
	$Plugins{SortUpdatedImg} = "";

	if ($Param{Dir} ==1){$Temp = $Language{topics_sort_up};}
	else{$Temp = $Language{topics_sort_dn};}

	if ($Param{Sort} eq "Title") {$Temp =~ s/<!--Link-->/$Plugins{SortTitle}/; $Plugins{SortTitleImg} = $Temp;}
	elsif ($Param{Sort} eq "Replies") {$Temp =~ s/<!--Link-->/$Plugins{SortReplies}/; $Plugins{SortRepliesImg} = $Temp;}
	elsif ($Param{Sort} eq "Author") {$Temp =~ s/<!--Link-->/$Plugins{SortAuthor}/; $Plugins{SortAuthorImg} = $Temp;}
	elsif ($Param{Sort} eq "Views") {$Temp =~ s/<!--Link-->/$Plugins{SortViews}/; $Plugins{SortViewsImg} = $Temp;}
	elsif ($Param{Sort} eq "Time") {$Temp =~ s/<!--Link-->/$Plugins{SortTime}/; $Plugins{SortTimeImg} = $Temp;}
	elsif ($Param{Sort} eq "Updated") {$Temp =~ s/<!--Link-->/$Plugins{SortUpdated}/; $Plugins{SortUpdatedImg} = $Temp;}
	#------------------------------------------------------
	# display the post new topic link?
	if ($PostLink) {
					$Link = $Language{forum_post_new_topic};
					$Temp = qq!$Script_URL?action=NewTopic&Forum=$Param{Forum}&Lang=$Global{Language}!;
					$Link =~ s/<!--NewTopicLink-->/$Temp/g;
	}
	else{
					$Link = "";
	}
	$Template =~ s/<!--PostNewTopic-->/$Link/g;
	#------------------------------------------------------
	return $Template;
	#&Display($Template, 1);
}
#==========================================================
sub GetForumUserTopicsRead{
my ($User, @Topics) = @_;
my ($Topic, $Topics, $Query, $sth, %Topics);

	if (!@Topics) {return;}
	#------------------------------------------------------
	# if no user (Guest), assume all topics read
	if (!$User) {
			foreach $Topic (@Topics) {
					$Topics{$Topic} = 1;
			}
			return %Topics;
	}
	#------------------------------------------------------
	$Topics = join (",", @Topics);
	$User = $dbh->quote($User);

	$Query = qq!SELECT Topic FROM Forum_Topic_Read WHERE Topic IN ($Topics) AND User=$User!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);

	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Topics;
	while(($Topic) = $sth->fetchrow_array) {
			$Topics{$Topic} = 1;
	}
	$sth->finish;
	return %Topics;
}
#==========================================================
sub Get_Forum_Periods_Menu{
my ($Default) = @_;
my ($Form, @Periods, %Labels, $Options, $Line, $Period, $Label, $Temp);

	$Form = &Translate($Global{Forum_Period});

	#$Global{Forum_Periods} = qq!0a,0.42h,0.25H,1d,2D,3D,1w,2W,1m,3M,6M,1y!;
	@Periods = split(/\,/, $Global{Forum_Periods});
	#----------------------------------------------------------
	%Labels = (
							a => $Language{all_periods},
							h => $Language{hour_label},
							H => $Language{hours_label},
							d => $Language{day_label},
							D => $Language{days_label},
							w => $Language{week_label},
							W => $Language{weeks_label},
							m => $Language{month_label},
							M => $Language{months_label},
							y => $Language{year_label},
							Y => $Language{years_label}
						);
	#----------------------------------------------------------
	$Options = "";
	foreach $Line (@Periods) {
				if ($Line =~ /([0-9\.]+)(.+)$/) {
						$Period = $1;
						$Label = $2;
				}
				if ($Line eq $Default) {$Sel = "selected";} else { $Sel = "";}
				$Option = $Language{forum_period_menu_option};
				if ($Period <= 0) {$Period = "";}
				$Option =~ s/<!--Period-->/$Line/g;
				$Option =~ s/<!--Value-->/$Period/g;
				$Option =~ s/<!--Selected-->/$Sel/g;
				$Option =~ s/<!--Label-->/$Labels{$Label}/g;
				$Options .= $Option;
	}
	#----------------------------------------------------------
	$Form =~ s/<!--Periods-->/$Options/g;

	$Temp = qq!$Script_URL?action=Forums&Forum=$Param{Forum}&Period=!;
	$Form =~ s/<!--JumpPeriodLink-->/$Temp/g;

	$Form =~ s/<!--Action-->/$Script_URL/g;
	$Form =~ s/<!--Language-->/$Global{Language}/g;

	$Plugins{Forum_Periods_Menu} = $Form;

	return $Form;
}
#==========================================================
sub Forum_Periods_Time{
my ($Input) = @_;	
my (@Periods, $Line, $Period, $Label, %Times);

	@Periods = split(/\,/, $Global{Forum_Periods});
	
	$Period = ""; $Label = "";
	foreach $Line (@Periods) {
			if ($Line eq $Input) {
					if ($Line =~ /([0-9\.]+)(.+)$/) {
							$Period = $1;
							$Label = $2;
					}
					last;
			}
	}

	%Times = (
						a => 0,
						h => 3600,
						H => 3600,
						d => 24*3600,
						D => 24*3600,
						w => 7*24*3600,
						W => 7*24*3600,
						m => 30*24*3600,
						M => 30*24*3600,
						y => 364*24*3600,
						Y => 364*24*3600
					);
	return ($Period * $Times{$Label});
}
#==========================================================
sub Get_Forum_Display_Last_Menu{
my ($Default) = @_;
my ($Form, @Periods, %Labels, $Options, $Line, $Period, $Label, $Temp);

	$Form = &Translate($Global{Forum_Display_Last});

	#$Global{Forum_Periods} = qq!0a,0.42h,0.25H,1d,2D,3D,1w,2W,1m,3M,6M,1y!;
	@Periods = split(/\,/, $Global{Forum_Display_Last_Periods});
	#----------------------------------------------------------
	%Labels = (
							a => $Language{all_periods},
							h => $Language{hour_label},
							H => $Language{hours_label},
							d => $Language{day_label},
							D => $Language{days_label},
							w => $Language{week_label},
							W => $Language{weeks_label},
							m => $Language{month_label},
							M => $Language{months_label},
							y => $Language{year_label},
							Y => $Language{years_label}
						);
	#----------------------------------------------------------
	$Options = "";
	foreach $Line (@Periods) {
				if ($Line =~ /([0-9\.]+)(.+)$/) {
						$Period = $1;
						$Label = $2;
				}
				if ($Line eq $Default) {$Sel = "selected";} else { $Sel = "";}
				$Option = $Language{forum_display_last_menu_option};
				if ($Period <= 0) {$Period = "";}
				$Option =~ s/<!--Period-->/$Line/g;
				$Option =~ s/<!--Value-->/$Period/g;
				$Option =~ s/<!--Selected-->/$Sel/g;
				$Option =~ s/<!--Label-->/$Labels{$Label}/g;
				$Options .= $Option;
	}
	#----------------------------------------------------------
	$Form =~ s/<!--Periods-->/$Options/g;

	$Temp = qq!$Script_URL?action=DisplayLast&Forum=$Param{Forum}&Period=!;
	$Form =~ s/<!--JumpPeriodLink-->/$Temp/g;

	$Form =~ s/<!--Action-->/$Script_URL/g;
	$Form =~ s/<!--Language-->/$Global{Language}/g;

	$Plugins{Forum_Display_Last_Menu} = $Form;

	return $Form;
}
#==========================================================
sub GetForumUserUnreadCount {
my ($User, $Forum) = @_;

	if (!$Forum) {return;}
	
	$User = $dbh->quote($User);
	#------------------------------------------------------
	# get the user read topics
	$Query = qq!SELECT Topic FROM Forum_Topic_Read WHERE User=$User!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Topics;
	while(($Topic) = $sth->fetchrow_array) {
			push @Topics, $Topic;
	}
	$sth->finish;
	#------------------------------------------------------
	if (!@Topics) {return 0;}
	#------------------------------------------------------
	$Topics = join (",", @Topics);

	$Query = qq!SELECT Topic FROM Forum_Topics WHERE Forum=$Forum AND Topic NOT IN ($Topics)!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Topics;
	while(($Topic) = $sth->fetchrow_array) {
			push @Topics, $Topic;
	}
	$sth->finish;
	#------------------------------------------------------
	return @Topics;
}
#==========================================================
sub GetForumTreeUserUnreadCount {
my ($User, $Forum) = @_;
my (@Forums, $Forums, $Query, $sth, @Topics, $Topic, $Topics);

	if (!$Forum) {return;}
	#@Forums = &GetSubForums($Forum);
	@Forums = &GetForumTree($Forum);
	
	push @Forums, $Forum;
	$Forums = join (",", @Forums);
	
	$User = $dbh->quote($User);
	#------------------------------------------------------
	# get the user read topics
	$Query = qq!SELECT Topic FROM Forum_Topic_Read WHERE User=$User!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Topics;
	while(($Topic) = $sth->fetchrow_array) {
			push @Topics, $Topic;
	}
	$sth->finish;
	#------------------------------------------------------
	if (!@Topics) {return 0;}
	#------------------------------------------------------
	$Topics = join (",", @Topics);

	$Query = qq!SELECT Topic FROM Forum_Topics WHERE Forum IN ($Forums) AND Topic NOT IN ($Topics)!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Topics;
	while(($Topic) = $sth->fetchrow_array) {
			push @Topics, $Topic;
	}
	$sth->finish;
	#------------------------------------------------------
	return @Topics;
}
#==========================================================
sub GetForumMenuBar {
my ($Bar, @Bar, $ID_Ref, $Name_Ref, @ID, @Name, $x, $Link, $Temp);	

	$Bar = &Translate($Global{Forum_Menu_Bar});

	undef @Bar;
	push @Bar, $Language{bar_home};

	if ($Param{Forum}) {
			($ID_Ref, $Name_Ref) = &GetForumFullname($Param{Forum});
			@ID = @{$ID_Ref};
			@Name = @{$Name_Ref};

			 for $x (0..$#ID) {
				 $Link = $Language{bar_forum_link};
				 $Temp = qq!$Script_URL?action=Forums&Forum=$ID[$x]&Lang=$Global{Language}!;
				 $Link =~ s/<!--ForumLink-->/$Temp/g;
				 $Link =~ s/<!--ForumName-->/$Name[$x]/g;
				 push @Bar, $Link;
			}

	}
	if ($Plugins{Bar_Action}) {push @Bar, $Plugins{Bar_Action};}
	
	$Temp = join ($Language{bar_separator}, @Bar);
	$Bar =~ s/<!--MenuBar-->/$Temp/;

	return $Bar;
}
#==========================================================
sub GetForum{
my ($Forum) = @_;
my ($Query, %Forum, $sth);

	if (!$Forum) {return undef;}
	$Query = qq!SELECT * FROM Forum_Forums WHERE Forum=$Forum!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Forum;
	while ($Temp = $sth->fetchrow_hashref){%Forum = %{$Temp}; last;}
	$sth->finish;
	return %Forum;
}
#==========================================================
sub GetSubForums{
my ($Forum) = shift;
my ($Query, @Forums, $sth, $ID);

	if ($Forum !~ m/^\d+$/) {return undef;}
	$Query = qq!SELECT Forum FROM Forum_Forums WHERE Parent=$Forum ORDER BY Sort ASC!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Forums;
	while(($ID) = $sth->fetchrow_array) {push @Forums, $ID;}
	$sth->finish;
	return @Forums;
}
#==========================================================
sub GetForumFullname{
my ($Forum) = @_;
my ($sth, $Query, $Parent, $Name, $ID, @Name, @ID);

	if (!$Forum) {$Forum = 0;}
	
	$Query = qq!SELECT Parent, Name FROM Forum_Forums WHERE Forum=$Forum ORDER BY Name, Sort!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	($Parent, $Name) = $sth->fetchrow_array ;

	undef @Name;
	undef @ID;
	push @Name, $Name;
	push @ID, $Forum;

	while ($Parent > 0 ) {
			$Query = qq!SELECT Forum, Parent, Name FROM Forum_Forums WHERE Forum=$Parent ORDER BY Name, Sort!;
			$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			$sth->execute() || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			($Forum, $Parent, $Name) = $sth->fetchrow_array;
			push @ID, $Forum;
			push @Name, $Name;
	}

	$sth->finish;

	@Name = reverse @Name;
	@ID = reverse @ID;
	
	return (\@ID, \@Name);
}
#==========================================================
sub GetForumTree{
my ($Forum) = @_;
my ($sth, $Query, @Categories, @Saved);

	if (!$Forum) {$Forum = 0;}
	undef @Forums;

	$Query = qq!SELECT Forum FROM Forum_Forums WHERE Parent=$Forum ORDER BY Sort ASC, Name ASC !;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	
	while (($ID) = $sth->fetchrow_array) {
		push @Forums, $ID;
	}

	@Saved = @Forums;
	while (@Forums) {
			$Forum = shift (@Forums);
			$Query = qq!SELECT Forum FROM Forum_Forums WHERE Parent=$Forum ORDER BY Sort ASC, Name ASC!;
			$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			while($ID = $sth->fetchrow_array) {
					push @Forums, $ID;
					push @Saved, $ID;
			}
	}

	$sth->finish;

	return @Saved;
}
#==========================================================
sub ForumsTreeForm{
my ($ForumID, $Action)=@_;
my (@Forums, $Out, $Counter, @Tree, $Forum, @Forums);
my ($ID_Ref, $Name_Ref, @ID, @Name, $x, $Last, $Levels);
my ($Line, $Width, %Forum, $Temp, $Link, $Sel);

	$ForumID ||= 0;
	@Forums = &GetForumTree($ForumID);

	$Out = ""; $Counter = 0;
	undef @Tree;

	foreach  $Forum (@Forums) {
			($ID_Ref, $Name_Ref) = &GetForumFullname($Forum);
			@ID = @{$ID_Ref};
			@{$Tree[$Counter]}{Forum} = $ID[$#ID];
			@{$Tree[$Counter]}{Name} = join("~|~", @{$Name_Ref});
			@{$Tree[$Counter]}{Sort} = $Counter;
			$Counter++;
	}

	@Tree = sort {$a->{Name} cmp $b->{Name}} @Tree;

	for  $x (0..$#Tree) {
			@Name = split(/~\|~/, $Tree[$x]{Name});
			$Last = pop @Name;

			$Levels = @Name;
			if ($Levels > 0) {$Width = $Levels * 30;} else {$Width = 0;}

			%Forum = &GetForum($Tree[$x]{Forum});
			if (!$Forum{Topics}) {$Forum{Topics} = "0";}
			
			if (!$Levels) { #Main Forums
					$Line = $Global{ForumsTreeMainForm};
			}
			else{ #Sub forums
					$Line = $Global{ForumsTreeMainSubForm};
			}
			
			$Line =~ s/<!--Levels-->/$Width/g; 
			$Line =~ s/<!--Images_URL-->/$Global{Images_URL}/g;
			$Line =~ s/<!--Name-->/$Last/g;
			
			$Link = qq!$Script_URL?action=$Action&Forum=$Tree[$x]{Forum}&Lang=$Global{Language}!;					
			$Line =~ s/<!--Link-->/$Link/g;
			
			if ($Tree[$x]{Forum} == $Param{Forum}) {$Sel = "selected";} else {$Sel = "";}
			$Line =~ s/<!--Selected-->/$Sel/g;

			if ($Forum{Topics} > 0) {$Temp = $Forum{Topics};} else {$Temp = $Language{tree_zero_topics};}
			$Line =~ s/<!--Topics-->/$Temp/g;
			if ($Forum{Posts} > 0) {$Temp = $Forum{Posts};} else {$Temp = $Language{tree_zero_posts};}
			$Line =~ s/<!--Posts-->/$Temp/g;
			$Out .= $Line;
	}

	return $Out;
}
#==========================================================
sub ForumsTreeMenuList{
my ($ForumID, $All) = @_;
my (@Forums, $Out, $Counter, @Tree, $Forum, @Forums);
my ($ID_Ref, $Name_Ref, @ID, @Name, $x, $Last, $Levels);
my ($Line, $Width, %Forum, $Temp);

	$ForumID ||= 0;
	@Forums = &GetForumTree($ForumID);

	$Out = "";
	if ($All==1) { # all forums menu option
			$Out = $Language{forums_menu_list_all};
			if (!$Param{Forum}) {$Sel = "selected";} else {$Sel = "";}
			$Out =~ s/<!--Selected-->/$Sel/g;
	}
	elsif ($All==2) { # jump to main forums menu option
			$Out = $Language{forums_menu_main};
			if (!$Param{Forum}) {$Sel = "selected";} else {$Sel = "";}
			$Out =~ s/<!--Selected-->/$Sel/g;
	}

	$Counter = 0;
	undef @Tree;

	foreach  $Forum (@Forums) {
			($ID_Ref, $Name_Ref) = &GetForumFullname($Forum);
			@ID = @{$ID_Ref};
			@{$Tree[$Counter]}{Forum} = $ID[$#ID];
			@{$Tree[$Counter]}{Name} = join("~|~", @{$Name_Ref});
			@{$Tree[$Counter]}{Sort} = $Counter;
			$Counter++;
	}

	@Tree = sort {$a->{Name} cmp $b->{Name}} @Tree;

	for  $x (0..$#Tree) {
			@Name = split(/~\|~/, $Tree[$x]{Name});
			$Last = pop @Name;

			$Levels = @Name;
			if ($Levels > 0) {
					$Width = $Levels * 4;
			}
			else{
					$Width = 0;
			}

			%Forum = &GetForum($Tree[$x]{Forum});
			
			if (!$Levels) { #Main Forums
					$Line = $Language{forums_menu_main_line};
			}
			else{ #Sub forums
					$Line = $Language{forums_menu_list_line};
			}
			
			$Temp = "&nbsp;" x $Width;
			$Line =~ s/<!--Levels-->/$Temp/g; 

			$Line =~ s/<!--Name-->/$Last/g;
			$Line =~ s/<!--Forum-->/$Tree[$x]{Forum}/g;

			if ($Tree[$x]{Forum} == $Param{Forum}) {$Sel = "selected";} else {$Sel = "";}
			$Line =~ s/<!--Selected-->/$Sel/g;

			if ($Forum{Topics} > 0) {$Temp = $Forum{Topics};} else {$Temp = $Language{tree_zero_topics};}
			$Line =~ s/<!--Topics-->/$Temp/g;
			
			if ($Forum{Posts} > 0) {$Temp = $Forum{Posts};} else {$Temp = $Language{tree_zero_posts};}
			$Line =~ s/<!--Posts-->/$Temp/g;

			$Out .= $Line;
	}

	return $Out;
}
#==========================================================
sub LoadCurrentUser{

	undef %CurrentUser;
	&Check_Previous_User_Login;

	if ($Param{User_ID}) {
			%CurrentUser = &GetForumUser($Param{User_ID});
	}
	
	return %CurrentUser;
	#%Groups = (0=>"Everyone", 1=>"Registered Users", 2=>"Private Groups", 3=>"Moderators", 4=>"Administartors");
}
#==========================================================
sub GetForumUserLevel{
my ($User_ID) = @_;
my ($Query, $Level, $sth, $Temp);

	$User_ID = $dbh->quote($User_ID);
	$Query = qq!SELECT Level FROM Forum_Users_Info WHERE User_ID=$User_ID!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute() || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Level = 0;
	while (($Temp) = $sth->fetchrow_hashref){$Level = $Temp; last;}
	$sth->finish;
	return $Level;
}
#==========================================================
sub UpdateForumUserInfo{
my ($User_ID, %Info) = @_;
my ($Query, $Field);
	
	$User_ID = $dbh->quote($User_ID);
	
	$Query = qq!UPDATE Forum_Users_Info SET !;
	
	foreach $Field (keys %Info) {
			next if ($Field eq "User_ID");
			$Query .= "$Field=". $dbh->quote($Info{$Field}) .",";
	}

	$Query =~ s/\,$//g;
	$Query .= qq! WHERE User_ID=$User_ID!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
}
#==========================================================
sub GetForumUserInfo{
my ($User_ID) = @_;
my ($Query, %User, $sth);

	$User_ID = $dbh->quote($User_ID);
	$Query = qq!SELECT * FROM Forum_Users_Info WHERE User_ID=$User_ID!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute() || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %User;
	while ($Temp = $sth->fetchrow_hashref){%User = %{$Temp}; last;}
	$sth->finish;
	return %User;
}
#==========================================================
sub GetForumUser{
my ($User_ID) = @_;
my ($Query, %User, $sth);

	$User_ID = $dbh->quote($User_ID);
	$Query = qq!SELECT * FROM Users, Forum_Users_Info WHERE
						  Users.User_ID=$User_ID AND Forum_Users_Info.User_ID=$User_ID!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute() || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %User;
	while ($Temp = $sth->fetchrow_hashref){%User = %{$Temp};}
	$sth->finish;

	return %User;
}
#==========================================================
sub GetForumUserWatchingTopics{
my ($User, $SortBy, $SortDir, $Period) = @_;
my ($Query, @Topics, $Dir, $TimeFilter, $Sort);
	
	if ($SortDir ==1 ) {$Dir = "ASC";	} else {$Dir = "DESC";}

	$TimeFilter = "";
	if ($Period > 0) {
			$TimeFilter = " AND (time>" . (time - $Period) .")"; # $Period is in seconds
	}

	$Sort = "";
	if ($SortBy) {
			$Sort = qq!ORDER BY $SortBy $Dir!;
	}

	
	$User = $dbh->quote($User);
	#------------------------------------------------------
	# get the topics this user is watching, no sorting
	$Query = qq!SELECT Topic FROM Forum_Watching WHERE User=$User!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Topics;
	while(($ID) = $sth->fetchrow_array) {push @Topics, $ID;}
	$sth->finish;
	#------------------------------------------------------
	if (!@Topics) {return @Topics;}
	#------------------------------------------------------
	# sort topics
	$Topics =  join (",", @Topics);
	$Query = qq!SELECT Topic FROM Forum_Topics WHERE Topic IN ($Topics) $TimeFilter GROUP BY Topic ORDER BY $SortBy $Dir!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Topics;
	while(($Temp) = $sth->fetchrow_array) {push @Topics, $Temp;}
	$sth->finish;
	#------------------------------------------------------
	$Global{Total_Matched_Count} = @Topics;

	return @Topics;
}
#==========================================================
sub GetModeratorForums{
my ($User) = @_;
my ($Query, $sth, $ID, %Forums);

	$User = $dbh->quote($User);
	$Query = qq!SELECT Forum FROM Forum_Moderators WHERE User=$User!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Forums;
	while(($ID) = $sth->fetchrow_array) {$Forums{$ID} = 1;}
	$sth->finish;
	return %Forums;
}
#==========================================================
sub CheckPostActionPermissions{
my ($Action, %Post) = @_;
	
	#Forum permissions (0=>"Everyone", 1=>"Registered Users", 2=>"Private Groups", 3=>"Moderators", 4=>"Administartors");
	#User  Levels : # 0=User, 1=Admin, 2=Mod

	%Forum = &GetForum($Post{Forum});
	#------------------------------------------------------
	# check if Everyone can delete
	if ($Forum{$Action} == 0) {return 1;}
	#------------------------------------------------------
	# if current user is the owner of the post, then allow him if forum permissions allow registered
	if ($CurrentUser{Level} == 0 && $Forum{$Action} == 1 && ($Post{Author} eq $Param{User_ID}) ) {return 1;}
	#------------------------------------------------------
	# if current user is Admin, then allow him to do anything
	if ($CurrentUser{Level} == 1) {return 1;}
	#------------------------------------------------------
	# if current user is Moderator, then check if he is a moderator for this forum
	if ($CurrentUser{Level} == 2 && $Forum{$Action} == 3) {
			if (&CheckForumModerator($Param{User_ID}, $Post{Forum})) {
					return 1;
			}
	}
	#------------------------------------------------------
	# all checks failed, not allowed operation
	return 0;
	#------------------------------------------------------
}
#==========================================================
sub CheckForumActionPermissions{
my ($Action, %Forum) = @_;
	
	#Forum permissions (0=>"Everyone", 1=>"Registered Users", 2=>"Private Groups", 3=>"Moderators", 4=>"Administartors");
	#User  Levels : # 0=User, 1=Admin, 2=Mod
	#------------------------------------------------------
	# check if Everyone is allowed
	if ($Forum{$Action} == 0) {return 1;}
	#------------------------------------------------------
	# if current user is Administrator, then allow to do anything
	if ($CurrentUser{Level} == 1) {return 1;}
	#------------------------------------------------------
	# if current user is registered and forum permissions allow registered
	if ($CurrentUser{User_ID} ne "" && $CurrentUser{Level} == 0 && $CurrentUser{$Action} == 1 && $Forum{$Action} == 1) {return 1;}
	#------------------------------------------------------
	# if current user is moderator or administrator, he has the registered users permissions also
	if ($CurrentUser{Level} == 1 || $CurrentUser{Level} == 2){
			if ($CurrentUser{$Action} == 1 && ($Forum{$Action} == 1 || $Forum{$Action} == 2 || $Forum{$Action} == 3)) {return 1;}
	}
	#------------------------------------------------------
	# if current user is Moderator, then check if he is a moderator for this forum
	if ($CurrentUser{Level} == 2){
		 if ($Forum{$Action} == 3 || $Forum{$Action} == 1) {
				if (&CheckForumModerator($Param{User_ID}, $Forum{Forum})) {
						return 1;
				}
		 }
	}
	#------------------------------------------------------
	# if this is a private forum, check if the current user belongs to any group of this forum
	if ($Forum{$Action} == 2) {
			if (&CheckPrivateForumUser($Param{User_ID}, $Forum{Forum})) {
					return 1;
			}
	}
	#------------------------------------------------------
	# all checks failed, not allowed operation
	return 0;
	#------------------------------------------------------
}
#==========================================================
sub CheckTopicActionPermissions{
my ($Action, %Topic) = @_;
	
	#Forum permissions (0=>"Everyone", 1=>"Registered Users", 2=>"Private Groups", 3=>"Moderators", 4=>"Administartors");
	#User  Levels : # 0=User, 1=Admin, 2=Mod

	%Forum = &GetForum($Topic{Forum});
	#------------------------------------------------------
	# check if Everyone can delete
	if ($Forum{$Action} == 0) {return 1;}
	#------------------------------------------------------
	# if current user is the topic starter, then allow him if forum permissions allow registered
	#if ($CurrentUser{Level} == 0 && $Forum{$Action} == 1 && ($Topic{Author} eq $Param{User_ID}) ) {return 1;}
	#------------------------------------------------------
	# if current user is Admin, then allow him to do anything
	if ($CurrentUser{Level} == 1) {return 1;}
	#------------------------------------------------------
	# if current user is Moderator, then check if he is a moderator for this forum
	if ($CurrentUser{Level} == 2 && $Forum{$Action} == 3) {
			# get all the forums for this moderator 
			#%Forums = &GetModeratorForums($Param{User_ID});
			#if ($Forums{$Topic{Forum}}) {return 1;}
			if (&CheckForumModerator($Param{User_ID}, $Topic{Forum})) {
					return 1;
			}
	}
	#------------------------------------------------------
	# all checks failed, not allowed operation
	return 0;
	#------------------------------------------------------
}
#==========================================================
sub CheckForumModerator{
my ($User, $Forum) = @_;
my ($Query, $sth, $Found, $Temp);

	if (!$Forum || !$User) {return 0;}
	$User = $dbh->quote($User);
	$Query = qq!SELECT User FROM Forum_Moderators WHERE Forum=$Forum AND User=$User ORDER BY User ASC!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Found = 0;
	while(($Temp) = $sth->fetchrow_array) {$Found = 1; last;}
	$sth->finish;
	return $Found;
}
#==========================================================
sub CheckPrivateForumUser{
my ($User, $Forum) = @_;
my ($Query, $sth, $Found, $Temp);

	if (!$Forum || !$User) {return 0;}
	$User = $dbh->quote($User);

	$Found = 01;
	#while(($Temp) = $sth->fetchrow_array) {$Found = 1; last;}
	#$sth->finish;
	return $Found;
}
#==========================================================
sub GetForumModerators{
my ($Forum) = @_;
my ($Query, $sth, @Users);

	if (!$Forum) {return "";}
	$Query = qq!SELECT User FROM Forum_Moderators WHERE Forum=$Forum ORDER BY User ASC!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Users;
	while(($ID) = $sth->fetchrow_array) {push @Users, $ID;}
	$sth->finish;
	return @Users;
}
#==========================================================
sub DeleteForumTopic{
my ($Topic) = @_;
my ($Query, @Posts, $Posts);

	@Posts = &GetForumTopicPosts($Topic);
	$Posts = join (",", @Posts);

	if ($Posts) {
			#--------------------------------------------------------------------------------------
			# Delete attached files for topics posts
			$Query = qq!SELECT Media FROM Forum_Media WHERE Post IN($Posts)!;
			$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
			undef @Media;
			while (($Temp) = $sth->fetchrow_array){push @Media, $Temp;}
			$sth->finish;

			foreach $Media (@Media) {
					@Files = split(/\|/, $Media);
					foreach $File (@Files){
							unlink ("$Global{Upload_Dir}/$File");
					}
			}
			#--------------------------------------------------------------------------------------
			$Query = qq!DELETE FROM Forum_Posts WHERE Post IN ($Posts)!;
			$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);

			$Query = qq!DELETE FROM Forum_Messages WHERE Post IN ($Posts)!;
			$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);

			$Query = qq!DELETE FROM Forum_Media WHERE Post IN ($Posts)!;
			$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	}

	$Query = qq!DELETE FROM Forum_Topics WHERE Topic=$Topic!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);

	$Query = qq!DELETE FROM Forum_Watching WHERE Topic=$Topic!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	
	$Query = qq!DELETE FROM Forum_Topic_Read WHERE Topic=$Topic!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);

	$Query = qq!DELETE FROM Forum_Topic_Notify WHERE Topic=$Topic!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
}
#==========================================================
sub UpdateForumsCounts{
my ($Topics, $Posts);

	($Topics) = &UpdateForumsTopicsCounts;
	($Posts) = &UpdateForumsPostsCounts;
	&UpdateForumsConfig("TotalTopics", $Topics);
	&UpdateForumsConfig("TotalPosts", $Posts);
}
#==========================================================
sub UpdateForumsTopicsCounts{
my (%Counts, %Forums, %Count, $Forum, %SubsCount);
my ($Total, $Query, $sth, %Parent, $Count, $Parent);

	%Counts = &GetForumsTopicsCounts;
	%Forums = &GetAllForumsID;

	$Total = 0;
	foreach $Forum (keys %Forums) {
			if (!$Counts{$Forum}) {$Counts{$Forum} = 0;}
			$Count{$Forum} = $Counts{$Forum};
			$Total += $Counts{$Forum};
	}

	%SubsCount = %Count;

	$Query = qq!SELECT Forum, Parent FROM Forum_Forums!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Parent;
	while(($Forum, $Parent) = $sth->fetchrow_array) {
				$Parent{$Forum}=$Parent;
	}
	$sth->finish;

	while (($Forum, $Count) =each (%Count)){
			$Parent = $Parent{$Forum};
			while ($Parent > 0) {
						$SubsCount{$Parent} += $Count;
						$Parent = $Parent{$Parent};
			}
	}

	while (($Forum, $Count) =each (%SubsCount)){
			$Query = qq!UPDATE  Forum_Forums SET Topics=$Count, SubTopics=$Count{$Forum} WHERE Forum=$Forum!;
			$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	}

	return ($Total);
}
#==========================================================
sub UpdateForumsPostsCounts{
my (%Counts, %Forums, %Count, $Forum, %SubsCount);
my ($Total, $Query, $sth, %Parent, $Count, $Parent);

	%Counts = &GetForumsPostsCounts;
	%Forums = &GetAllForumsID;

	$Total = 0;
	foreach $Forum (keys %Forums) {
			if (!$Counts{$Forum}) {$Counts{$Forum} = 0;}
			$Count{$Forum} = $Counts{$Forum};
			$Total += $Counts{$Forum};
	}

	%SubsCount = %Count;

	$Query = qq!SELECT Forum, Parent FROM Forum_Forums!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Parent;
	while(($Forum, $Parent) = $sth->fetchrow_array) {
				$Parent{$Forum}=$Parent;
	}
	$sth->finish;

	while (($Forum, $Count) =each (%Count)){
			$Parent = $Parent{$Forum};
			while ($Parent > 0) {
						$SubsCount{$Parent} += $Count;
						$Parent = $Parent{$Parent};
			}
	}

	while (($Forum, $Count) =each (%SubsCount)){
			$Query = qq!UPDATE  Forum_Forums SET Posts=$Count, SubPosts=$Count{$Forum} WHERE Forum=$Forum!;
			$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	}

	return ($Total);
}
#==========================================================
sub GetForumsTopicsCounts{
my(%Count, $Query, $Forum, $Count, $sth);

	$Query = qq!SELECT Forum, COUNT(Topic) FROM Forum_Topics GROUP BY Forum!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Count;
	while(($Forum, $Count) = $sth->fetchrow_array) {
			$Count{$Forum} = $Count;
	}
	$sth->finish;
	return %Count;
}
#==========================================================
sub GetForumsPostsCounts{
my(%Count, $Query, $Forum, $Count, $sth);

	$Query = qq!SELECT Forum, COUNT(Post) FROM Forum_Posts GROUP BY Forum!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef %Count;
	while(($Forum, $Count) = $sth->fetchrow_array) {
			$Count{$Forum} = $Count;
	}
	$sth->finish;
	return %Count;
}
#==========================================================
sub WatchingTopicStatus{
my ($User, $Topic) = @_;
my ($Query, $sth, $Found, $Temp);

	$User = $dbh->quote($User);
	$Query = qq!SELECT User FROM Forum_Watching WHERE Topic=$Topic AND User=$User!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Found = 0;
	while(($Temp) = $sth->fetchrow_array) {$Found = 1; last;}
	$sth->finish;
	return $Found;
}
#==========================================================
sub NotifyTopicStatus{
my ($User, $Topic) = @_;
my ($Query, $sth, $Found, $Temp);

	$User = $dbh->quote($User);
	$Query = qq!SELECT User FROM Forum_Topic_Notify WHERE Topic=$Topic AND User=$User!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Found = 0;
	while(($Temp) = $sth->fetchrow_array) {$Found = 1; last;}
	$sth->finish;
	return $Found;
}
#==========================================================
sub NotifyTopicSent{
my ($User, $Topic) = @_;
my ($Query, $sth, $Status, $Temp);

	$User = $dbh->quote($User);
	$Query = qq!SELECT Status FROM Forum_Topic_Notify WHERE Topic=$Topic AND User=$User!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$Status = 0;
	while(($Temp) = $sth->fetchrow_array) {$Status = 1; last;}
	$sth->finish;
	return $Status;
}
#==========================================================
sub GetNotifyTopicUsersList{
my ($Topic) = @_;
my ($Query, $sth, @Users, $Temp);

	$Query = qq!SELECT User FROM Forum_Topic_Notify WHERE Topic=$Topic AND Status=0!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
	undef @Users;
	while(($Temp) = $sth->fetchrow_array) {push @Users, $Temp;}
	$sth->finish;
	return @Users;
}
#==========================================================
sub UpdateNotifyTopicUsersList{
my ($Topic, $Status, @Users) = @_;
my ($Query, $User, $Users);

	if (!$Topic || !@Users) {return;}

	$Users = "";
	foreach $User (@Users) {
			$Users .= $dbh->quote($User);
	}
	$Query = qq!UPDATE Forum_Topic_Notify SET Status=$Status WHERE Topic=$Topic AND User IN($Users)!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
}
#==========================================================
sub Get_User_Feedback_Stars{
my ($User_ID) = @_;
my ($User, $Temp, $Total, $Positive, $Neutral, $Negative);
my ($Query, $sth, @Row, $Image, $Link);

	$User = $dbh->quote($User_ID);
	$Query = qq!SELECT * FROM FeedbackRating WHERE User_ID=$User!;
	$sth = $dbh->prepare($Query) || &DB_Exit($Query."<BR>Line ". __LINE__ . ", File ". __FILE__);
	$sth->execute || &DB_Exit($Query."<BR>Line ". __LINE__ . ", File ". __FILE__);
	
	$Total = 0; $Positive = 0; $Neutral = 0; $Negative = 0;
	while(@Row = $sth->fetchrow_array) {
			($Temp, $Total, $Positive, $Neutral, $Negative) = @Row; last;
	}
	$sth->finish;

	$Image = &Rating_Stars_Image($Total);

	if ($Image) {
			$Link = $Language{feedback_stars_link};
			$Link =~ s/<!--Stars_Image-->/$Image/;
	}
	else{
			$Link = "";
	}
	return ($Total, $Link);
}
#==========================================================
sub Rating_Stars_Image{
my ($Rating) = @_;
my (@Stars, $Star, $From, $To, $Image);

	@Stars = split (/\|/, $Language{feedback_stars});

	foreach $Star (@Stars) {
			($From, $To, $Image) = split(/\:/, $Star);
			if ($Rating >= $From && $Rating <= $To) {
				return $Image;
			}
	}
	return "";
}
#==========================================================
sub MarkTopicRead{
my ($User, $Topic) = @_;

	$User = $dbh->quote($User);
	$Query = qq!DELETE From Forum_Topic_Read WHERE Topic=$Topic AND User=$User!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);

	$Query = qq!INSERT INTO Forum_Topic_Read SET Topic=$Topic, User=$User!;
	$dbh->do($Query) || &DB_Exit($Query."<br>Line ". __LINE__ . ", File ". __FILE__);
}
#==========================================================
sub PrepareForumSearchTerms{
my ($Terms) = @_;
my (@Terms, $Terms1, $Temp, $x, $Term, $Found);
		
	#$Terms =~ s/<[^>]+>//ig; # remove html code
	$Terms =~ s/^\s+//;
	$Terms =~ s/\s+$//;
	$Terms || return "";
	$Global{Required_Search_Term} =~ s/\*+/\%/g;

	$Terms =~ s/\s+/ /g;
	$Terms =~ s/\'/\\'/g;
	$Terms =~ s/\s*\+\s*/ and /ig;

	$Global{Required_Search_Term} = $Terms;

	$Terms =~ s/ and not / -/ig;
	$Terms =~ s/ and / \+/ig;
	$Terms =~ s/ not / -/ig;        
	$Terms =~ s/ or / \|/ig;

	#$Terms =~ s/\*+/\\S*\\W/g;
	$Terms =~ s/\*+/\%/g;
	$Terms1 = $Terms;

	while( $Terms1 =~ m|"([^\"\\]*(?:\\.[^\"\\]*)*)"|gx ) { 
					$Temp = $1;
					$Temp1= $Temp;
					$Temp1 =~ s/^\s+//;
					$Temp1 =~ s/\s+$//;
					$Temp1 =~ s/\s+/\_/g;
					$Terms =~ s/$Temp/$Temp1/g;
	}

	$Terms =~ s/\"//g;
	$Global{Required_Search_Term} =~ s/\"//g;

	@Terms = split(/\s+/, $Terms);

	for $x (0..$#Terms) {
		$Terms[$x] =~ s/\%+/\%/g;
		$Terms[$x] =~ s/\_/ /g;
		if ($Terms[$x] =~ /\-/) {
				$Global{Required_Search_Term} =~ s/$Terms[$x]//g;
		}
	}

	$Global{Required_Search_Term} =~ s/\s+/ /g;
	
	$Found = 0;
	foreach $Term (@Terms) {
			if ($Global{Required_Search_Term} eq "*") { next;}
			if ($Term =~ /$Global{Required_Search_Term}/) {$Found = 1; last;}
	}
	if (!$Found) {
			unshift @Terms , "|$Global{Required_Search_Term}";
	}

	return @Terms;
}
#==========================================================

1;